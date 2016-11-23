class CreateSpreeBulkProductEditItems < ActiveRecord::Migration
  def change
    create_table :spree_bulk_product_edit_items do |t|
      t.integer :bulk_product_edit_id, index: true
      t.integer :product_id, index: true
    end

    add_foreign_key :spree_bulk_product_edit_items, :spree_bulk_product_edits, column: :bulk_product_edit_id
    add_foreign_key :spree_bulk_product_edit_items, :spree_products, column: :product_id
  end
end
