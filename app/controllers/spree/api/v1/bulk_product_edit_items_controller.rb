module Spree
  module Api
    module V1
      class BulkProductEditItemsController < Spree::Api::BaseController

        def products_for_selection
          @taxon_products = products_by_taxon
          @selected_products = selected_products
          filter_taxon_products
          @products = (@taxon_products + @selected_products).sort! { |x, y| x['name'] <=> y['name'] }
          render json: { products: @products }
        end

        private

        def products_by_taxon
          taxon_ids = params[:taxon_ids]
          products = []
          Spree::Taxon.where(id: taxon_ids).each do |taxon|
            base_taxon_products = taxon.products
            children_taxon_products = taxon.children.includes(:products).map(&:products).flatten.compact.uniq
            products += (base_taxon_products + children_taxon_products).uniq
          end
          products.map! { |p| p.attributes }.each { |p| p[:selected] = false }
        end

        def selected_products
          bulk_product_edit_id = params[:bulk_product_edit_id]
          product_ids = Spree::BulkProductEditItem.where(bulk_product_edit_id: bulk_product_edit_id).pluck(:product_id)
          products = Spree::Product.where(id: product_ids).to_a.map! { |p| p.attributes }.each { |p| p[:selected] = true }
        end

        def filter_taxon_products
          @taxon_products.reject! { |p| in_selected? p }
        end

        def in_selected? product
          @selected_products.index { |s| s['id'] == product['id'] }
        end

      end
    end
  end
end
