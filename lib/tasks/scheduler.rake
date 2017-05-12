desc "Executes any pending bulk edits via spreadsheet data"
task :execute_pending_bulk_product_spreadsheet_edits => :environment do

  edit = Spree::BulkProductSpreadsheetEdit.where(state: Spree::BulkProductSpreadsheetEdit::STATE_PENDING).order(:id).first
  edit.execute_edit unless edit.nil?

end
