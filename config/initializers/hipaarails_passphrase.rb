# Be sure to restart your server when you modify this file.

require 'hipaarails'

SampleApp::Application.config.hipaarails_cipher = HIPAARails::config.options[:cipher]

if ENV['DATABASE_URL'].nil? # FIXME XXX Hack to check if NOT running on heroku
    if Rails.env == 'production'
        SampleApp::Application.config.hipaarails_passphrase =
            HIPAARails::generate_key_with_default_salt
    else
        SampleApp::Application.config.hipaarails_passphrase =
            HIPAARails::generate_key_with_default_passphrase
    end
else # assume heroku
    if ENV['ENCRYPTION_PASSPHRASE'].nil?
        raise StandardError, "Please set ENV['ENCRYPTION_PASSPHRASE']" +
           " using `heroku config:add ENCRYPTION_PASSPHRASE=passphrase`"
            + "before pushing"
    end
    SampleApp::Application.config.hipaarails_passphrase =
            ENV['ENCRYPTION_PASSPHRASE']
end
