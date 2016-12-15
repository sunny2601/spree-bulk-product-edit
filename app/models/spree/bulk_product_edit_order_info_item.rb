module Spree
  class BulkProductEditOrderInfoItem < ActiveRecord::Base
    self.table_name = 'spree_bulk_product_edits_order_info_items'
    belongs_to :bulk_product_edit
    belongs_to :order_info_item
  end
end
