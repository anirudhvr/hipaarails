HIPAARails
==========

This gem is intended to be a rails plugin that can make HIPAA compliance
for a Rails 3+ developer easy by allowing easy encryption of sensitive
model attributes, as well as comprehensive audit/logging of these
fields. 

This is still a work in progress.

What it does
============

This gem allows users to encrypt/decrypt model attributes easily (with
the help of the attr\_encrypted gem) using a passphrase-based key that
can optionally be stored remotely. In addition, it uses the paper\_trail
gem to audit accesses to model fields in a separate table


Dependencies
============

attr_encrypted: https://github.com/shuber/attr_encrypted

paper_trail: https://github.com/airblade/paper_trail

Usage
=====

1. Specify the hipaarails gem in your Rails Gemfile:
`gem 'hipaarails', :git => "git://github.com/oakenshield/hipaarails"`
2. `bundle install`. This should also pull the dependencies
3. Copy config/initializers/hipaarails\_passphrase.rb to config/initializers in the app 
4. Copy lib/hipaarails.yml to the config/ directory in the app
5. In a model, specify the fields that must be encrypted. For example,
   if a User model has the following accessible attributes: 
   `attr_accessible :name, :email, :password, :password_confirmation`
   It can have the email attribute transparently encrypted as follows:
   `attr_encrypted :email, key: SampleApp::Application.config.hipaarails_passphrase,
                        cipher: SampleApp::Application.config.hipaarails_cipher`

  
