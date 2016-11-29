module Spree
  module Admin
    class BulkProductEditItemsController < ResourceController

      before_action :load_bulk_product_edit, except: [:create, :update]

      def index
        product_ids = Spree::BulkProductEditItem.where(bulk_product_edit: @bulk_product_edit).pluck(:product_id)
        @collection = Spree::Product.includes(master: [:images]).where(id: product_ids).order(:name)

        case params[:select_by]
          when 'taxon'
            render 'select_by_taxon'
          when 'sku'
            render 'select_by_sku'
          else
            render 'select_by_taxon'
        end
      end

      def create
        Spree::BulkProductEditItem.delete_all(bulk_product_edit_id: params[:bulk_product_edit_id])
        params[:product_ids].each do |id|
          Spree::BulkProductEditItem.create({ product_id: id, bulk_product_edit_id: params[:bulk_product_edit_id] })
        end

        flash[:success] = 'Product list updated'

        case params[:select_by]
          when 'taxon'
            redirect_to select_by_taxon_admin_bulk_product_edit_bulk_product_edit_items_path params[:bulk_product_edit_id]
          when 'sku'
            redirect_to select_by_sku_admin_bulk_product_edit_bulk_product_edit_items_path params[:bulk_product_edit_id]
        end
      end

      private

      def load_bulk_product_edit
        @bulk_product_edit = Spree::BulkProductEdit.find(params[:bulk_product_edit_id])
      end

      def product_details
        details = {}
        details['product_price'] = params[:product_price] if is_number? params[:product_price]
        details['sample_price'] = params[:sample_price] if is_number? params[:sample_price]
        details['available_on'] = Date.strptime(params[:available_on], '%Y/%m/%d').to_time unless params[:available_on].nil?
        details['discontinue_on'] = Date.strptime(params[:discontinue_on], '%Y/%m/%d').to_time unless params[:discontinue_on].blank?
        details['weight'] = params[:weight] if is_number? params[:weight]
        details['height'] = params[:height] if is_number? params[:height]
        details['width'] = params[:width] if is_number? params[:width]
        details['depth'] = params[:depth] if is_number? params[:depth]
        details['sale_unit_id'] = params[:sale_unit_id] unless params[:sale_unit_id].blank?
        details['country_of_origin'] = params[:country_of_origin] unless params[:country_of_origin].blank?

        details
      end

      def is_number? string
        true if Float(string) rescue false
      end

    end
  end
end
