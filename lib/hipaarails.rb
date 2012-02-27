$LOAD_PATH.unshift(File.dirname(__FILE__))


require 'openssl'
require 'hipaarails/config'

module HIPAARails
    autoload :Version, 'hipaarails/version'

    def self.enabled=(val)
        return HIPAARails.Config.enabled = val
    end

    def self.enabled?
        # also takes care of nil
        !!HIPAARails.Config.enabled
    end

    def self.ask_for_passphrase
        puts "Enter passphrase"
        pass = ask_for_password
        return pass
    end

    def self.generate_key
        pass = self.ask_for_password
        if HIPAARails::Config.error?
            raise StandardError, HIPAARails::Config.error_message
            return nil
        end

        unless validate_password(pass, HIPAARails::Config.options[:min_passphrase_length])
            raise StandardError, "Passphrase should be at least " +
                "#{HIPAARails::Config.options[:min_passphrase_length]} chars" 
        end

        case HIPAARails::Config.options[:key_derivation_algorithm]
        when 'pbkdf2'
            salt =
                SecureRandom.base64(HIPAARails::Config.options[:key_salt_length])
            iter = HIPAARails::Config.options[:key_derivation_cost * 1000]
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

    def self.config
        # Config is a Singleton class
        @@config ||= HIPAARails::Config.instance
    end

    #
    # Auth prototypes lifted from Heroku client code
    #
    def with_tty(&block)
        return unless $stdin.tty?
        begin
            yield
        rescue
            # fails on windows
        end
    end

    def ask
        $STDIN.gets.strip
    end

    def echo_off
        with_tty do
            system "stty -echo"
        end
    end

    def echo_on
        with_tty do
            system "stty echo"
        end
    end

    def ask_for_password
        echo_off
        trap("INT") do
            echo_on
            exit
        end
        password = ask
        puts
        echo_on
        return password
    end

end
