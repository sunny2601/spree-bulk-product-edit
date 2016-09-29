module Spree
  class BulkProductEditItem < Spree::Base

    #belongs_to :product
    belongs_to :bulk_product_edit

    validates :product_id, :bulk_product_edit_id, presence: true

  end
end
