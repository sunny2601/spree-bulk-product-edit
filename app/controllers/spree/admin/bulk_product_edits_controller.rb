module Spree
  module Admin
    class BulkProductEditsController < ResourceController

      update.before :update_before

      def index
        respond_with(@collection)
      end

      def product_details
        @bulk_product_edit = Spree::BulkProductEdit.find(params[:bulk_product_edit_id])
        @sale_units = Spree::SaleUnit.order(:name)
        @countries = Spree::Country.all
      end

      # def product_details_update
      #   details = ???
      #   @tmp = details
      #
      #   @products = products
      #   render 'tmp'
      # end

      # def product_properties_update

      #   @tmp = self.properties
      #
      #   @products = products
      #   render 'tmp'
      # end

      private

      # def after_update_path_for(resource)
      #   edit_admin_bulk_product_edit_path(resource)
      # end

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

      # def details
      #   details = {}
      #   details[:]
      #
      #     'product_price'] = params[:product_price] if is_number? params[:product_price]
      #     details['sample_price'] = params[:sample_price] if is_number? params[:sample_price]
      #     details['available_on'] = Date.strptime(params[:available_on], '%Y/%m/%d').to_time unless params[:available_on].nil?
      #     details['discontinue_on'] = Date.strptime(params[:discontinue_on], '%Y/%m/%d').to_time unless params[:discontinue_on].blank?
      #     details['weight'] = params[:weight] if is_number? params[:weight]
      #     details['height'] = params[:height] if is_number? params[:height]
      #     details['width'] = params[:width] if is_number? params[:width]
      #     details['depth'] = params[:depth] if is_number? params[:depth]
      #     details['sale_unit_id'] = params[:sale_unit_id] unless params[:sale_unit_id].blank?
      #     details['country_of_origin'
      #   end
      # end

    end
  end
end
