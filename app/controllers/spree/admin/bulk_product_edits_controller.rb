module Spree
  module Admin
    class BulkProductEditsController < ResourceController

      update.before :update_before

      def index
        respond_with(@collection)
      end

      private

      def after_update_path_for(resource)
        edit_admin_bulk_product_edit_path(resource)
      end

      def permitted_resource_params
        params.require(:bulk_product_edit)
            .permit(:id, :name, :product_price, :sample_price, :available_on, :discontinue_on,
                    :weight, :height, :width, :depth, :sale_unit_id, :country_of_origin, bulk_product_edit_properties_attributes: [:id, :property_name, :value])
      end

      def collection
        return @collection if @collection.present?

        params[:q] ||= {}

        params[:q][:s] ||= 'created_at desc'
        @collection = super

        @search = @collection.ransack(params[:q])
        @collection = @search.result.
            page(params[:page]).
            per(params[:per_page] || SpreeBulkProductEdit.configuration.admin_edits_per_page)
        @collection
      end

      def update_before
        # note: we only reset the product properties if we're receiving a post
        #       from the form on that tab
        return unless params[:clear_bulk_product_edit_properties]
        params[:product] ||= {}
      end

    end
  end
end
