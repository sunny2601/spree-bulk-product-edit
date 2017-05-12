class CreateSpreeBulkProductSpreadsheetEdit < ActiveRecord::Migration
  def change
    create_table :spree_bulk_product_spreadsheet_edits do |t|
      t.string :name, null: false
      t.string :edit_type, null: false
      t.string :state, default: 'pending'
      t.timestamps null: false
    end
    add_attachment :spree_bulk_product_spreadsheet_edits, :spreadsheet_file
  end
end
