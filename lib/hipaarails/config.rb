require 'singleton'
require 'yaml'

module HIPAARails
    class Config
        CONFIG_FILE_NAME = "hipaarails.yml"

        include Singleton
        attr_accessor :enabled, :options, :error

        def initialize(config_file=nil)
            @enabled = true
            @error = false
            begin
                if config_file.nil? && !Rails.nil?
                    config_file = Rails.configuration.root.to_s +
                        "/config/#{CONFIG_FILE_NAME}"
                    @options  = YAML.load_file(config_file)
                else
                    # default options
                    @options = { key_derivation_algorithm: 'pbkdf2',
                        key_derivation_cost: 1,
                        min_passphrase_length: 10,
                        default_salt: "thisisabadsalt;changeme!",
                        cipher: 'aes-128-cbc'}
                end
            rescue StandardError => e
                @error = true
                @error_message = e.to_s
            end
        end

        def error?
            return @error
        end

        def error_message
            return @error_message
        end

    end
end
