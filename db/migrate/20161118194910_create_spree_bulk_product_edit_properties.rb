class CreateSpreeBulkProductEditProperties < ActiveRecord::Migration
  def change
    create_table :spree_bulk_product_edit_properties do |t|
      t.integer :bulk_product_edit_id
      t.integer :property_id
      t.string :value
      t.integer :position, index: true
      t.timestamps null: false
    end

    add_foreign_key :spree_bulk_product_edit_properties, :spree_bulk_product_edits, column: :bulk_product_edit_id
    add_foreign_key :spree_bulk_product_edit_properties, :spree_properties, column: :property_id
  end
end
