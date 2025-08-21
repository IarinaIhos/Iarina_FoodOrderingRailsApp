# frozen_string_literal: true

class AddDeviseToUsers < ActiveRecord::Migration[8.0]
      def self.up
        change_table :users do |t|
          ## Database authenticatable
          # Remove password_digest if it exists
          if column_exists?(:users, :password_digest)
            t.remove :password_digest
          end
          
          # Add encrypted_password only if it doesn't exist
          unless column_exists?(:users, :encrypted_password)
            t.string :encrypted_password, null: false, default: ""
          end
      
          ## Recoverable
          unless column_exists?(:users, :reset_password_token)
            t.string :reset_password_token
          end
          unless column_exists?(:users, :reset_password_sent_at)
            t.datetime :reset_password_sent_at
          end
      
          ## Rememberable
          unless column_exists?(:users, :remember_created_at)
            t.datetime :remember_created_at
          end
        end
      
        # Add index only if it doesn't exist
        unless index_exists?(:users, :reset_password_token)
          add_index :users, :reset_password_token, unique: true
        end
      end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
