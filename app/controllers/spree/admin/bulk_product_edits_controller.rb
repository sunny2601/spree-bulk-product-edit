module Spree
  module Admin
    class BulkProductEditsController < ResourceController

      update.before :update_before
      before_action :get_bulk_product_edit, only: [:product_details, :apply_updates, :update_products]

      def index
        respond_with(@collection)
      end

      def product_details
        # @bulk_product_edit = Spree::BulkProductEdit.find(params[:bulk_product_edit_id])
        @sale_units = Spree::SaleUnit.order(:name)
        @countries = Spree::Country.all
      end

      def apply_updates
        @details = extract_product_details
        @properties = @bulk_product_edit.properties
      end

      def update_products
        # @bulk_product_edit = Spree::BulkProductEdit.find(params[:bulk_product_edit_id])
        @products = products
        @properties = @bulk_product_edit.properties
        render 'tmp'
      end

      private

      def get_bulk_product_edit
        @bulk_product_edit = Spree::BulkProductEdit.find(params[:bulk_product_edit_id])
      end

      def location_after_save
        return admin_bulk_product_edit_product_details_path(@bulk_product_edit) if params['update_product_details'].present?
        return admin_bulk_product_edit_bulk_product_edit_properties_path(@bulk_product_edit) if params['update_product_properties'].present?
        return edit_admin_bulk_product_edit_path(@bulk_product_edit)
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
        # note: we only reset the bulk product edit properties if we're receiving a post from the form on that tab
        return unless params[:clear_bulk_product_edit_properties]
        params[:bulk_product_edit] ||= {}
      end

      def products
        product_ids = Spree::BulkProductEditItem.where(bulk_product_edit_id: params[:bulk_product_edit_id]).pluck(:product_id)
        Spree::Product.where(id: product_ids)
      end

      def extract_product_details
        details = {}
        Spree::BulkProductEdit::PRODUCT_DETAILS_FIELDNAMES.each do |fieldname|
          details[fieldname] = @bulk_product_edit.send(fieldname.to_sym) if @bulk_product_edit.send(fieldname.to_sym).present?
        end
        details
      end

    end
  end
end
