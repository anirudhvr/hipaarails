$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'openssl'
require 'hipaarails/config'
require 'singleton'

module HIPAARails
    autoload :Version, 'hipaarails/version'

    attr_accessor @@config

    def self.enabled=(val)
        return HIPAARails.Config.enabled = val
    end

    def self.enabled?
        # also takes care of nil
        !!HIPAARails.Config.enabled
    end

    def self.generate_key_with_default_passphrase
        self.config
        self.generate_key(@@config.options[:default_passphrase], 
                          @@config.options[:default_salt])
    end

    def self.generate_key_with_default_salt
        self.config
        pass = self.ask_for_password
        self.generate_key(pass, @@config.options[:default_salt])
    end

    def self.generate_key(pass, salt=nil)
        self.config

        if @@config.error?
            raise StandardError, @@config.error_message
            return nil
        end

        unless validate_password(pass, @@config.options[:min_passphrase_length])
            raise StandardError, "Passphrase should be at least " +
                "#{@@config.options[:min_passphrase_length]} chars" 
        end

        require 'securerandom'
        case @@config.options[:key_derivation_algorithm]
        when 'pbkdf2'
            if salt.nil?
                salt =
                    SecureRandom.base64(@@config.options[:key_salt_length])
            end
            iter = @@config.options[:key_derivation_cost].to_i * 1000
            keylen = 128 # FIXME
            key = OpenSSL::PKCS5::pbkdf2_hmac_sha1(pass, salt, iter,
                                                   keylen)
            return key
        when 'bcrypt2'
            raise StandardError, "Not implemented"
            return nil
        end
    end


    private

    def self.validate_password(pass, length)
        pass.length >= length ? true : false
    end

    def self.config
        # Config is a Singleton class
        @@config ||= HIPAARails::Config.instance
    end

    #
    # Auth prototypes lifted from Heroku client code
    #
    def self.with_tty(&block)
        return unless $stdin.tty?
        begin
            yield
        rescue
            # fails on windows
        end
    end

    def self.ask
        $stdin.gets.strip
    end

    def self.echo_off
        with_tty do
            system "stty -echo"
        end
    end

    def self.echo_on
        with_tty do
            system "stty echo"
        end
    end

    def self.ask_for_password
        print "Enter passphrase: "
        echo_off
        trap("INT") do
            echo_on
            exit
        end
        password = self.ask
        puts
        echo_on
        return password
    end

end
