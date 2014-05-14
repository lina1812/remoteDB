class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :email,              :null => false, :default => ""
      t.string :is_student ,             :null => false, :default =>"1"
      t.string :is_teacher ,             :null => false, :default =>"0"
      t.string :is_admin ,             :null => false, :default =>"0"
      t.string :encrypted_password, :null => false, :default => ""
      t.integer :group,		:null=>false, :default =>0
      t.string :name, 			:nill=>false, :default =>""
      t.string :surname, 			:nill=>false, :default =>""
      t.string :last_name, 			:nill=>false, :default =>""
      
      
      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0, :null => false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0, :null => false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true


    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    create_table :databases_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :database
    end
  end
end
