module Spree
  class BulkProductEdit < Spree::Base

    has_many :bulk_product_edit_items

    has_many :bulk_product_edit_properties, dependent: :destroy, inverse_of: :bulk_product_edit
    has_many :properties, through: :bulk_product_edit_properties

    accepts_nested_attributes_for :bulk_product_edit_properties, allow_destroy: true, reject_if: lambda { |pp| pp[:property_name].blank? }

    self.whitelisted_ransackable_attributes =  %w[created_at]

    validates :name, presence: true

  end
end
