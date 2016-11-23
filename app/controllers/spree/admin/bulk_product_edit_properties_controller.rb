module Spree
  module Admin
    class BulkProductEditPropertiesController < ResourceController
      belongs_to 'spree/bulk_product_edit'

      # before_action :find_bulk_product_edit
      before_action :find_properties
      before_action :setup_property, only: :index

      private

      # def find_bulk_product_edit
      #   @bulk_product_edit = Spree::BulkProductEdit.find(params[:bulk_product_edit_id])
      # end

      def find_properties
        @properties = Spree::Property.pluck(:name)
      end

      def setup_property
        @bulk_product_edit.bulk_product_edit_properties.build
      end
    end
  end
end
