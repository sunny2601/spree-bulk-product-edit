Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :bulk_product_edits do

      get 'product_details', to: 'bulk_product_edits#product_details'
      post 'product_details', to: 'bulk_product_edits#product_details_update'

      get 'review_updates', to: 'bulk_product_edits#review_updates'
      get 'update_products', to: 'bulk_product_edits#update_products'

      resources :bulk_product_edit_properties do
        collection do
          post :update_positions
        end
      end

      resources :bulk_product_edit_items do
        collection do
          get 'select_by_taxon', to: 'bulk_product_edit_items#index', defaults: { select_by: 'taxon' }
          get 'select_by_sku', to: 'bulk_product_edit_items#index', defaults: { select_by: 'sku' }
        end
      end

      resources :bulk_product_edit_order_info_items, only: [:index]

    end

    resources :bulk_product_spreadsheet_edits
  end

  namespace :api do
    namespace :v1 do
      get 'bulk_product_edit_items/products_for_selection', to: 'bulk_product_edit_items#products_for_selection', defaults: { format: 'json' }
    end
  end
end
