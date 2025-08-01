class CreateAdminProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :admin_products do |t|
      t.string :name
      t.string :category
      t.string :diet
      t.decimal :price
      t.text :description

      t.timestamps
    end
  end
end
