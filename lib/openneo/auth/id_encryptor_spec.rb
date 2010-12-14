require 'rubygems'
require 'devise/encryptors/base'

require File.join(File.dirname(__FILE__), 'id_encryptor')

describe Devise::Encryptors::OpenneoId do
  it "should encrypt passwords just like the original app" do
    Devise::Encryptors::OpenneoId.digest(
      'myPa$$w0rd!!!',
      1,
      'abcdefg',
      nil
    ).should == '21a11dc7562b1e3919594a623636a4cdfea6d6f5cd3a168a2f842f7bc4f3da46'
    
    Devise::Encryptors::OpenneoId.digest(
      'HELLO_WORLD',
      1,
      '1234567',
      nil
    ).should == 'ae7ad79d35cb817af653a3fbb62a6be6f1b8bfc16b5a6b821979c8af7c2a5e67'
  end
end
