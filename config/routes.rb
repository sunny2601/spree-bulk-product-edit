Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :bulk_product_edits do

      resources :bulk_product_edit_items do

        collection do
          get 'product_details', to: 'bulk_product_edit_items#product_details_form'
          post 'product_details', to: 'bulk_product_edit_items#product_details_update'

          get 'product_properties', to: 'bulk_product_edit_items#product_properties_form'
          post 'product_properties', to: 'bulk_product_edit_items#product_properties_update'
        end

      end

    end
  end

  namespace :api do
    namespace :v1 do
      get 'bulk_product_edit_items/products_for_selection', to: 'bulk_product_edit_items#products_for_selection', defaults: { format: 'json' }
    end
  end
end
