class CreateSpreeBulkProductEdits < ActiveRecord::Migration
  def change
    create_table :spree_bulk_product_edits do |t|
      t.string :name
      t.timestamps null: false
    end
  end
end
