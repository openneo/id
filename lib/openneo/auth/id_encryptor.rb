require 'rubygems'
require 'hmac-sha2'

module Devise
  module Encryptors
    class OpenneoId < Base
      def self.digest(password, stretches, salt, pepper)
        hmac = HMAC::SHA256.new(salt)
        password.encode!('ISO-8859-1') if password.respond_to? :encode!
        hmac << password
        hmac.hexdigest
      end
    end
  end
end

