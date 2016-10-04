module Spree
  module Admin
    class BulkProductEditsController < ResourceController

      def index
        respond_with(@collection)
      end

      private

      def permitted_resource_params
        params.require(:bulk_product_edit).permit(:id, :name)
      end

      def collection
        return @collection if @collection.present?

        params[:q] ||= {}

        params[:q][:s] ||= 'created_at desc'
        @collection = super

        @search = @collection.ransack(params[:q])
        @collection = @search.result.
            page(params[:page]).
            per(params[:per_page] || SpreeBulkProductEdit.configuration.admin_bulk_product_edits_per_page)
        @collection
      end

    end
  end
end
