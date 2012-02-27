require File.expand_path('../test_helper', __FILE__)

class HIPAARailsTest < Test::Unit::TestCase

    algorithms = %x(openssl list-cipher-commands).split
    key = Digest::SHA256.hexdigest(([Time.now.to_s] * rand(3)).join)
    iv = Digest::SHA256.hexdigest(([Time.now.to_s] * rand(3)).join)
    original_value = Digest::SHA256.hexdigest(([Time.now.to_s] * rand(3)).join)

    define_method "test_should_crypt_with_the_#{algorithm}_algorithm_with_iv" do
        assert_not_equal original_value, encrypted_value_with_iv
        assert_not_equal encrypted_value_without_iv, encrypted_value_with_iv
        assert_equal original_value, Encryptor.decrypt(:value => encrypted_value_with_iv, :key => key, :iv => iv, :algorithm => algorithm)
    end


    def test_should_have_a_default_algorithm
        assert !Encryptor.default_options[:algorithm].nil?
        assert !Encryptor.default_options[:algorithm].empty?
    end

    def test_should_raise_argument_error_if_key_is_not_specified
        assert_raises(ArgumentError) { Encryptor.encrypt('some value') }
        assert_raises(ArgumentError) { Encryptor.decrypt('some encrypted string') }
        assert_raises(ArgumentError) { Encryptor.encrypt('some value', :key => '') }
        assert_raises(ArgumentError) { Encryptor.decrypt('some encrypted string', :key => '') }
    end

    def test_should_yield_block_with_cipher_and_options
        called = false
        Encryptor.encrypt('some value', :key => 'some key') { |cipher, options| called = true }
        assert called
    end

end
