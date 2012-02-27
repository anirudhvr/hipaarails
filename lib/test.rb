require './hipaarails'
require 'base64'

p = HIPAARails::generate_key_with_default_salt
p Base64.encode64(p)
