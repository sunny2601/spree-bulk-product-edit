module Spree
  module Admin
    class BulkProductSpreadsheetEditsController < ResourceController

      def index
        respond_with @collection
      end

      def permitted_resource_params
        params.require(:bulk_product_spreadsheet_edit).permit(:id, :name, :edit_type, :spreadsheet_file)
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

    end
  end
end
