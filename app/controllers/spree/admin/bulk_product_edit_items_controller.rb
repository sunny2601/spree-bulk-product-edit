module Spree
  module Admin
    class BulkProductEditItemsController < ResourceController

      # belongs_to 'spree/bulk_product_edit'
      before_action :load_bulk_product_edit, except: [:create, :update]

      def index
        # product_ids = Spree::BulkProductEditItem.where(id: @bulk_product_edit.id).map { |item| item.id }
        # @collection = Spree::Product.where(id: product_ids)

        @collection
      end

      private

      def collection
        #return @collection if @collection.present?

        params[:q] ||= {}



          params[:q][:deleted_at_null] ||= '1'

          params[:q][:s] ||= 'name asc'
          #@collection = super

          # Don't delete params[:q][:deleted_at_null] here because it is used in view to check the
          # checkbox for 'q[deleted_at_null]'. This also messed with pagination when deleted_at_null is checked.
          # if params[:q][:deleted_at_null] == '0'
          #   @collection = @collection.with_deleted
          # end
          # @search needs to be defined as this is passed to search_form_for

          # Temporarily remove params[:q][:deleted_at_null] from params[:q] to ransack products.
          # This is to include all products and not just deleted products.
          @search = Spree::Product.ransack(params[:q]) #.reject { |k, _v| k.to_s == 'deleted_at_null' })
          @collection = @search.result.
              distinct_by_product_ids(params[:q][:s]).
              #includes(product_includes).
              page(params[:page]).
              per(params[:per_page] || Spree::Config[:admin_products_per_page])




        @collection

      end

      def load_bulk_product_edit
        @bulk_product_edit = Spree::BulkProductEdit.find(params[:bulk_product_edit_id])
      end

    end
  end
end
