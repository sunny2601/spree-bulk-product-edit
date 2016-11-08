module Spree
  module Admin
    class BulkProductEditItemsController < ResourceController

      before_action :load_bulk_product_edit, except: [:create, :update]

      def index
        product_ids = Spree::BulkProductEditItem.where(bulk_product_edit: @bulk_product_edit).pluck(:product_id)
        @collection = Spree::Product.where(id: product_ids)
      end

      def create
        Spree::BulkProductEditItem.delete_all(bulk_product_edit_id: params[:bulk_product_edit_id])
        params[:product_ids].each do |id|
          Spree::BulkProductEditItem.create({ product_id: id, bulk_product_edit_id: params[:bulk_product_edit_id] })
        end
        redirect_to admin_bulk_product_edit_bulk_product_edit_items_path params[:bulk_product_edit_id]
      end

      private

      def load_bulk_product_edit
        @bulk_product_edit = Spree::BulkProductEdit.find(params[:bulk_product_edit_id])
      end

    end
  end
end
