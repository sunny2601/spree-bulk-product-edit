module Spree
  module Admin
    class BulkProductEditOrderInfoItemsController < ResourceController

      before_action :load_bulk_product_edit, only: [:index]
      before_action :load_order_info_item_ids, only: [:index]
      before_action :load_order_info_items, only: [:index]

      private

      def load_bulk_product_edit
        @bulk_product_edit = Spree::BulkProductEdit.find(params[:bulk_product_edit_id])
      end

      def load_order_info_item_ids
        @bulk_product_edit_order_info_item_ids = @bulk_product_edit.order_info_items.map(&:id)
      end

      def load_order_info_items
        @order_info_items = Spree::OrderInfoItem.all
      end

    end
  end
end

