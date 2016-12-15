class CreateSpreeBulkProductEditsOrderInfoItemsJoinTable < ActiveRecord::Migration
  def change
    create_table :spree_bulk_product_edits_order_info_items, { id: false } do |t|
      t.integer :bulk_product_edit_id
      t.integer :order_info_item_id
    end

    add_index :spree_bulk_product_edits_order_info_items, :bulk_product_edit_id, name: 'order_info_bulk_edits_join_bulk_product_edit_id'
    add_index :spree_bulk_product_edits_order_info_items, :order_info_item_id, name: 'order_info_bulk_edits_join_order_info_item_id'
  end
end
