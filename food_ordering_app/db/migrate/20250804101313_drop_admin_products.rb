class DropAdminProducts < ActiveRecord::Migration[8.0]
  def change
    drop_table :admin_products
  end
end
