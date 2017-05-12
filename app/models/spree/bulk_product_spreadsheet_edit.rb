module Spree
  class BulkProductSpreadsheetEdit < Spree::Base

    include Admin::BulkProductSpreadsheetEditHelper

    STATE_PENDING = 'pending'
    STATE_COMPLETE = 'complete'

    EDIT_TYPES = ['brewster_sale_units_and_pricing', 'brewster_expiration_dates']
    SHEET_NAMES = { brewster_sale_units_and_pricing: 'PricingByPattern', brewster_expiration_dates: 'Full OD List' }

    validates :name, :edit_type, presence: true
    validates_inclusion_of :edit_type, in: EDIT_TYPES

    has_attached_file :spreadsheet_file
    validates_attachment :spreadsheet_file, content_type: { content_type: ['application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'] }

    def can_edit?
      self.state != STATE_COMPLETE
    end

  end
end
