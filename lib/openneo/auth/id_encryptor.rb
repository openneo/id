require 'rubygems'
require 'hmac-sha2'

module Devise
  module Encryptors
    class OpenneoId < Base
      def self.digest(password, stretches, salt, pepper)
        hmac = HMAC::SHA256.new(salt)
        hmac << password
        hmac.hexdigest
      end
    end
  end
end
