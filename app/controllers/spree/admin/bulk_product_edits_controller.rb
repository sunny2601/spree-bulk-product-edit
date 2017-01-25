module Spree
  module Admin
    class BulkProductEditsController < ResourceController

      include ProductHelper
      include ActionController::Live
      require 'json'

      update.before :update_before
      before_action :get_bulk_product_edit, only: [:product_details, :review_updates, :update_products]

      def index
        respond_with(@collection)
      end

      def product_details
        @sale_units = Spree::SaleUnit.order(:name)
        @countries = Spree::Country.all
      end

      def review_updates
        @products = products
        @details = extract_product_details
        @order_info_items = @bulk_product_edit.order_info_items
        @properties = @bulk_product_edit.bulk_product_edit_properties
      end

      def update_products
        products.each do |product|
          set_product_details product
          set_product_ordering_information product
          set_product_properties product
        end

        # flash[:success] = 'Products updated'
        # redirect_to location_after_save

        response.headers['Content-Type'] = 'text/event-stream'

        item = { status: 'Products updated' }
        response.stream.write 'event: update'+$/
        response.stream.write 'data: '+item.to_json+$/+$/

      rescue IOError
        # client disconnected.
      ensure
        response.stream.close
      end

      private

      def get_bulk_product_edit
        @bulk_product_edit = Spree::BulkProductEdit.find(params[:bulk_product_edit_id])
      end

      def location_after_save
        return admin_bulk_product_edit_product_details_path(@bulk_product_edit) if params['update_product_details'].present?
        return admin_bulk_product_edit_bulk_product_edit_order_info_items_path(@bulk_product_edit) if params['update_ordering_information'].present?
        return admin_bulk_product_edit_bulk_product_edit_properties_path(@bulk_product_edit) if params['update_product_properties'].present?

        return edit_admin_bulk_product_edit_path(@bulk_product_edit)
      end

      def permitted_resource_params
        params.require(:bulk_product_edit)
            .permit(:id, :name, :master_price, :product_price, :sample_price, :available_on, :expires_on,
                :weight, :height, :width, :depth, :sale_unit_id, :country_of_origin,
                :clear_details, :clear_ordering_information, :clear_properties,
                order_info_item_ids: [],
                bulk_product_edit_properties_attributes: [:id, :property_name, :value])
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
          details[fieldname.to_sym] = @bulk_product_edit.send(fieldname.to_sym) if @bulk_product_edit.send(fieldname.to_sym).present?
        end

        if details[:sale_unit_id].present?
          details[:sale_unit] = Spree::SaleUnit.find(details[:sale_unit_id]).name
          details.delete(:sale_unit_id)
        end

        if details[:country_of_origin].present?
          details[:country_of_origin] = Spree::Country.find(details[:country_of_origin]).name
        end

        details
      end

      def set_product_details product
        product.master.price = @bulk_product_edit.master_price if @bulk_product_edit.master_price.present?

        product.variants.each do |variant|
          if variant_is_sample(variant)
            variant.price = @bulk_product_edit.sample_price if @bulk_product_edit.sample_price.present?
          else
            variant.price = @bulk_product_edit.product_price if @bulk_product_edit.product_price.present?
          end

          variant.weight = @bulk_product_edit.weight if @bulk_product_edit.weight.present?
          variant.height = @bulk_product_edit.height if @bulk_product_edit.height.present?
          variant.width = @bulk_product_edit.width if @bulk_product_edit.width.present?
          variant.depth = @bulk_product_edit.depth if @bulk_product_edit.depth.present?

          variant.save!
        end

        product.available_on = @bulk_product_edit.available_on if @bulk_product_edit.available_on.present?
        product.expires_on = @bulk_product_edit.expires_on if @bulk_product_edit.expires_on.present?

        product.sale_unit_id = @bulk_product_edit.sale_unit_id if @bulk_product_edit.sale_unit_id.present?
        product.country_of_origin = @bulk_product_edit.country_of_origin if @bulk_product_edit.country_of_origin.present?

        product.save!
      end

      def set_product_ordering_information product
        product.order_info_items = [] if @bulk_product_edit.clear_ordering_information
        @bulk_product_edit.order_info_items.each do |item|
          product.order_info_items << item unless product.order_info_items.include? item
        end
        product.save!
      end

      def set_product_properties product
        product.properties = [] if @bulk_product_edit.clear_properties
        @bulk_product_edit.bulk_product_edit_properties.each do |bulk_product_edit_property|
          product.set_property(bulk_product_edit_property.property.name, bulk_product_edit_property.value)
        end
        product.save!
      end

    end
  end
end
