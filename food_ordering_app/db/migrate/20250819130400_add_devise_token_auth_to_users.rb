class AddDeviseTokenAuthToUsers < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :provider, :string, null: false, default: 'email'
    add_column :users, :uid, :string, null: false, default: ''
    add_column :users, :tokens, :json
    
    # Update existing users to have unique uid values
    User.reset_column_information
    User.find_each do |user|
      user.update_column(:uid, user.email)
    end
    
    add_index :users, [:uid, :provider], unique: true
  end

  def down
    remove_index :users, [:uid, :provider]
    remove_column :users, :tokens
    remove_column :users, :uid
    remove_column :users, :provider
  end
end
