module Spree
  OrderInfoItem.class_eval do
    has_and_belongs_to_many :bulk_product_edits, :uniq => true, :join_table => :spree_bulk_product_edits_order_info_items
  end
end
