module Spree
  class BulkProductEdit < Spree::Base

    has_many :bulk_product_edit_items

    self.whitelisted_ransackable_attributes =  %w[created_at]

    validates :name, presence: true

    def self.setup
      yield self
    end

  end
end
