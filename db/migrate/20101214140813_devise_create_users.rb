class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    change_table(:users) do |t|
      t.rename :password_hash, :encrypted_password
      t.rename :secret, :password_salt
      t.recoverable
      t.rememberable
      t.trackable
      
      t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      
      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :unlock_token,         :unique => true
  end

  def self.down
    change_table(:users) do |t|
      t.rename :encrypted_password, :password_hash
      t.rename :password_salt, :secret
      # recoverable
      t.remove :reset_password_token
      # rememberable
      t.remove :remember_token
      t.remove :remember_created_at
      # trackable
      t.remove :sign_in_count
      t.remove :current_sign_in_at
      t.remove :last_sign_in_at
      t.remove :current_sign_in_ip
      t.remove :last_sign_in_ip
      # lockable
      t.remove :failed_attempts
      t.remove :unlock_token
      t.remove :locked_at
      # timestamps
      t.remove :created_at
      t.remove :updated_at
      
      t.remove_index :email
    end
  end
end
