class User < ActiveRecord::Base
  devise :database_authenticatable, :lockable, :registerable, :recoverable,
    :trackable, :validatable, :encryptable

  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  validates :name, :presence => true, :uniqueness => {:case_sensitive => false},
    :length => {:maximum => 20}
  validates :email, :length => {:maximum => 50}

  include Gravtastic
  gravtastic :rating => 'G', :default => 'http://images.neopets.com/neoboards/avatars/default.gif'

  def to_remote_packet_data
    {:id => id, :name => name}
  end
end
