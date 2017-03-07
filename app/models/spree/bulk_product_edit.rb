module Spree
  class BulkProductEdit < Spree::Base

    PRODUCT_DETAILS_FIELDNAMES = %w[
      master_price
      product_price
      sample_price
      available_on
      expires_on
      weight
      height
      width
      depth
      sale_unit_id
      country_of_origin
    ]

    has_many :bulk_product_edit_items, dependent: :destroy

    has_many :bulk_product_edit_properties, dependent: :destroy, inverse_of: :bulk_product_edit
    has_many :properties, through: :bulk_product_edit_properties

    has_and_belongs_to_many :order_info_items, :uniq => true, :join_table => :spree_bulk_product_edits_order_info_items

    accepts_nested_attributes_for :bulk_product_edit_properties, allow_destroy: true, reject_if: lambda { |pp| pp[:property_name].blank? }

    self.whitelisted_ransackable_attributes =  %w[created_at]

    validates :name, presence: true

    def set_order_info_item name
      item = Spree::OrderInfoItem.find_by(name: name)
      self.order_info_items << item unless item.nil? || self.order_info_items.include?(item)
    end

  end
end
