class CreateSpreeBulkProductEdits < ActiveRecord::Migration
  def change
    create_table :spree_bulk_product_edits do |t|
      t.string :name,  null: false
      t.decimal :master_price, precision: 8, scale: 2
      t.decimal :product_price, precision: 8, scale: 2
      t.decimal :sample_price, precision: 8, scale: 2
      t.datetime :available_on
      t.datetime :discontinue_on
      t.decimal :weight, precision: 8, scale: 2
      t.decimal :height, precision: 8, scale: 2
      t.decimal :width, precision: 8, scale: 2
      t.decimal :depth, precision: 8, scale: 2
      t.integer :sale_unit_id
      t.integer :country_of_origin
      t.boolean :clear_details, default: false
      t.boolean :clear_properties, default: false
      t.timestamps null: false
    end
  end
end
