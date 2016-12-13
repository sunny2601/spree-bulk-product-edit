module Spree
  class BulkProductEdit < Spree::Base

    PRODUCT_DETAILS_FIELDNAMES = %w[
      master_price
      product_price
      sample_price
      available_on
      discontinue_on
      weight
      height
      width
      depth
      sale_unit_id
      country_of_origin
    ]

    has_many :bulk_product_edit_items

    has_many :bulk_product_edit_properties, dependent: :destroy, inverse_of: :bulk_product_edit
    has_many :properties, through: :bulk_product_edit_properties

    accepts_nested_attributes_for :bulk_product_edit_properties, allow_destroy: true, reject_if: lambda { |pp| pp[:property_name].blank? }

    self.whitelisted_ransackable_attributes =  %w[created_at]

    validates :name, presence: true

  end
end
