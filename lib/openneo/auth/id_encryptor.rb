require 'rubygems'
require 'hmac-sha2'

module Devise
  module Encryptable
    module Encryptors
      class OpenneoId < Base
        def self.digest(password, stretches, salt, pepper)
          hmac = HMAC::SHA256.new(salt)
          
          begin
            # We used to use ISO-8859-1 encoding on the legacy app, so we're
            # keeping it so that legacy accounts continue to work as expected.
            password = password.encode('ISO-8859-1')
          rescue Encoding::UndefinedConversionError
            # Unless a password can't be represented in ISO-8859-1, in which case
            # we encode it in UTF-8. Sketchy, but works as expected without
            # migration.
            password = password.encode('UTF-8')
          end
          
          hmac << password
          hmac.hexdigest
        end
      end
    end
  end
end

