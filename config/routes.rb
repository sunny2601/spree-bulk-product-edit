Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :bulk_product_edits do
      resources :bulk_product_edit_items
    end
  end
end
