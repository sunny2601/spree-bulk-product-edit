class CreateSpreeBulkProductEditItems < ActiveRecord::Migration
  def change
    create_table :spree_bulk_product_edit_items do |t|
      t.integer :bulk_product_edit_id, index: true
      t.integer :product_id, index: true
    end
  end
end
