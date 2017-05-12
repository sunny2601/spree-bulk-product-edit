module Spree
  module Admin
    module BulkProductSpreadsheetEditHelper

      require 'roo'
      require 'roo-xls'

      PROPERTY_IDS = {
          count_by: 14,
          min_qty: 35,
          repeat_height: 7,
          roll_width: 30,
          sold_by: 15,
          sheet_width: 51,
          sheet_height: 52,
          sheet_count: 53
      }

      ORDER_INFO_ITEM_IDS = {
          untrimmed_white: 20,
          printed_width_can_vary: 21,
          qty_of_1_eq_30_square_feet: 19,
          printed_continuously_for_2_or_more: 17,
          printed_continuously_for_30_sq_ft_or_more: 25
      }

      SALE_UNIT_IDS = {
          double_roll: 3,
          meter: 10,
          set: 6,
          single_roll: 2,
          spool: 5,
          square_foot: 9,
          thirty_square_feet: 15
      }

      def execute_edit
        open_workbook
        load_worksheet
        process_worksheet
      end

      def open_workbook
        case self.edit_type
          when 'brewster_sale_units_and_pricing'
            @workbook = Roo::Spreadsheet.open(self.spreadsheet_file.to_s)
          when 'brewster_expiration_dates'
            @workbook = Roo::Spreadsheet.open(self.spreadsheet_file.to_s)
        end
      end

      def load_worksheet
        sheet_name = Spree::BulkProductSpreadsheetEdit::SHEET_NAMES[self.edit_type.to_sym]
        raise 'Expecting sheet '+sheet_name+', not found in workbook' unless @workbook.sheets.include? sheet_name
        @worksheet = @workbook.sheet(sheet_name)
      end

      def process_worksheet
        return if @worksheet.nil?

        case self.edit_type
          when 'brewster_sale_units_and_pricing'
            process_brewster_sale_units_and_pricing
          when 'brewster_expiration_dates'
            process_brewster_expiration_dates
        end
      end

      def process_brewster_sale_units_and_pricing

          # The last four columns are values pertaining to sale by double roll, which we don't use.
          # Their names are identical to the names of the columns we do want to use. We have to get
          # rid of them so their values don't overwrite the values we want.
          header = @worksheet.row(1)[0..8].map { |v| v.parameterize('_') }

          @worksheet.drop(1).each do |row|

            data = Hash[header.zip(row)].symbolize_keys

            product_id = product_id_from_sku(data[:pattern])
            next if product_id.nil?

            price = data[:map].nil? ? data[:msrp] : data[:map]
            sale_unit_id = sale_unit_id(data[:unit_of_measure])

            # pp data
            # puts $/

            puts "SKU: #{data[:pattern]}"
            puts "PRODUCT ID: #{product_id}"
            puts "SOLD BY: #{sold_by_name(sale_unit_id)}"
            puts "PRICE: #{price}"
            puts "SALE UNIT ID: #{sale_unit_id}"
            puts '- '*60

            set_product_sale_unit product_id, sale_unit_id
            set_product_property(product_id, PROPERTY_IDS[:sold_by], sold_by_name(sale_unit_id))

            if data[:unit_of_measure].downcase == 'single roll'
              set_product_property product_id, PROPERTY_IDS[:count_by], 2
              set_product_property product_id, PROPERTY_IDS[:min_qty], 2
            else
              set_product_property product_id, PROPERTY_IDS[:count_by], 1
              set_product_property product_id, PROPERTY_IDS[:min_qty], 1
            end

            if data[:unit_of_measure].downcase == 'each'
              delete_product_property product_id, PROPERTY_IDS[:roll_width]
              delete_product_property product_id, PROPERTY_IDS[:repeat_height]
            end

            set_product_price product_id, price

          end

          self.state = Spree::BulkProductSpreadsheetEdit::STATE_COMPLETE
          self.save!

      end

      def process_brewster_expiration_dates

        header = @worksheet.row(1).map { |v| v.parameterize('_') }

        @worksheet.drop(1).each do |row|

          data = Hash[header.zip(row)].symbolize_keys
          product_id = product_id_from_sku(data[:pattno])
          next if product_id.nil?

          pp data
          puts '- = '*30

          expires_on = data[:book_od_date].strftime '%F 00:00:00'
          set_product_expires_on product_id, expires_on

        end

        self.state = Spree::BulkProductSpreadsheetEdit::STATE_COMPLETE
        self.save!

      end

      def set_product_property product_id, property_id, value
        sql = "SELECT id FROM spree_product_properties WHERE product_id = #{product_id} AND property_id = #{property_id}"
        res = ActiveRecord::Base.connection.exec_query(sql)

        if res.rows.empty?
          product = Spree::Product.find(product_id)
          property = Spree::Property.find(property_id)
          product.set_property(property.name, value)
        else
          rows = res.to_hash
          product_property_id = OpenStruct.new(rows.first).id
          sql = "UPDATE spree_product_properties SET value = '#{value}', updated_at = '#{Time.now}' WHERE id = #{product_property_id}"
          ActiveRecord::Base.connection.execute(sql)
        end
      end

      def delete_product_property product_id, property_id
        sql = "DELETE FROM spree_product_properties WHERE product_id = #{product_id} AND property_id = #{property_id}"
        ActiveRecord::Base.connection.execute(sql)
      end

      def set_product_order_info_item product_id, order_info_item_id
        sql = "INSERT INTO order_info_items_spree_products ( product_id, order_info_item_id ) VALUES ( #{product_id}, #{order_info_item_id} )"
        ActiveRecord::Base.connection.execute(sql)
      end

      def delete_product_order_info_item product_id, order_info_item_id
        sql = "DELETE FROM order_info_items_spree_products WHERE product_id = #{product_id} AND order_info_item_id = #{order_info_item_id}"
        ActiveRecord::Base.connection.execute(sql)
      end

      def set_product_price product_id, price
        sql = "UPDATE spree_prices SET amount = '#{price}' WHERE variant_id IN(SELECT id FROM spree_variants WHERE product_id = #{product_id} AND (is_master = TRUE OR sku LIKE '%_full') AND deleted_at IS NULL) AND deleted_at IS NULL"
        ActiveRecord::Base.connection.execute(sql)
      end

      def set_product_sale_unit product_id, sale_unit_id
        sql = "UPDATE spree_products SET sale_unit_id = #{sale_unit_id}, updated_at = '#{Time.now}' WHERE id = #{product_id}"
        ActiveRecord::Base.connection.execute(sql)
      end

      def set_product_expires_on product_id, expires_on
        sql = "UPDATE spree_products SET expires_on = '#{expires_on}', updated_at = '#{Time.now}' WHERE id = #{product_id}"
        ActiveRecord::Base.connection.execute(sql)
      end

      def sample_variant product
        product.variants.select { |variant| variant.sku.match(/_sample$/) }.first

        # product.variants.select{ |variant| variant.option_values.select {
        #     |option_value| option_value.option_type_id == ITEM_OR_SAMPLE_OPTION_TYPE_ID && option_value.name == OPTION_TYPE_VALUE_NAMES[:sample]
        # }.first }.first
      end

      def full_variant product
        product.variants.select { |variant| variant.sku.match(/_full$/) }.first

        # product.variants.select{ |variant| variant.option_values.select {
        #     |option_value| option_value.option_type_id == ITEM_OR_SAMPLE_OPTION_TYPE_ID && option_value.name == OPTION_TYPE_VALUE_NAMES[:full]
        # }.first }.first
      end

      def sold_by_name sale_unit_id
        Spree::SaleUnit.find(sale_unit_id).name
      end

      def sale_unit_id unit
        case unit.downcase

          when 'single roll'
            SALE_UNIT_IDS[:single_roll]

          when 'double roll'
            SALE_UNIT_IDS[:double_roll]

          when 'each', 'set'
            SALE_UNIT_IDS[:set]

          when 'spool of border', 'spool'
            SALE_UNIT_IDS[:spool]

          when 'meter'
            SALE_UNIT_IDS[:meter]

          else
            raise 'No sale unit ID found'

        end
      end

      def product_id_from_sku sku
        sql = "SELECT product_id FROM spree_variants WHERE sku = '#{sku}' AND deleted_at IS NULL"
        res = ActiveRecord::Base.connection.exec_query(sql)
        unless res.rows.empty?
          rows = res.to_hash
          return OpenStruct.new(rows.first).product_id
        end
      end

    end
  end
end
