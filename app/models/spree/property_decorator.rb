Spree::Property.class_eval do

  has_many :bulk_product_edit_properties, dependent: :delete_all, inverse_of: :property
  has_many :products, through: :bulk_product_edit_properties

end
