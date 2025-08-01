class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :category
      t.string :diet
      t.decimal :price, precision: 8, scale: 2, null: false
      t.text :description
      t.timestamps
    end

    add_index :products, :category
    add_index :products, :diet
  end
end
