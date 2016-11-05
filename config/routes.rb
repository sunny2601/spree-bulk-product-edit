Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :bulk_product_edits do
      resources :bulk_product_edit_items
    end
  end

  namespace :api do
    namespace :v1 do
      get 'bulk_product_edit_items/products_for_selection', to: 'bulk_product_edit_items#products_for_selection', defaults: { format: 'json' }
    end
  end
end
