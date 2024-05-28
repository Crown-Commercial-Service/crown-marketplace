module FacilitiesManagement::RM6232
  module Admin
    class SupplierDataSnapshotGenerator
      def initialize(snapshot_date_time)
        @snapshot_date_time = snapshot_date_time + 1.minute
      end

      def build_zip_file
        set_data
        create_file_stream
      end

      def to_zip
        @file_stream.read
      end

      private

      def set_data
        supplier_data = FacilitiesManagement::RM6232::Admin::SupplierData.where(created_at: ..@snapshot_date_time).order(created_at: :desc).first

        supplier_data.edits.where(created_at: ..@snapshot_date_time).order(:created_at).each do |edit|
          supplier = supplier_data.data.find { |supplier_item| supplier_item['id'] == edit.supplier_id }

          if edit.change_type == 'lot_data'
            update_lot_data(edit, supplier)
          else
            update_details(edit, supplier)
          end
        end

        @supplier_data = supplier_data.data
      end

      def update_lot_data(edit, supplier)
        supplier_lot_data = supplier['lot_data'].find { |lot_data| lot_data['lot_code'] == edit.data['lot_code'] }

        lot_data_changes(edit, supplier_lot_data, 'removed', :delete)
        lot_data_changes(edit, supplier_lot_data, 'added', :push)
      end

      def lot_data_changes(edit, supplier_lot_data, key, method)
        edit.data[key].is_a?(Array) ? edit.data[key].each { |code| supplier_lot_data[edit.data['attribute']].send(method, code) } : supplier_lot_data[edit.data['attribute']] = edit.data[key]
      end

      def update_details(edit, supplier)
        edit.data.each { |detail| supplier[detail['attribute']] = detail['value'] }
      end

      def snapshot_date_time_string
        @snapshot_date_time_string ||= (@snapshot_date_time - 1.minute).in_time_zone('London').strftime('%d_%m_%Y %H_%M').squish
      end

      def create_file_stream
        supplier_details_spreadsheet = FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet::Details.new(@supplier_data, nil, true)
        supplier_details_spreadsheet.build

        supplier_services_spreadsheet = FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet::Services.new(@supplier_data)
        supplier_services_spreadsheet.build

        supplier_regions_spreadsheet = FacilitiesManagement::RM6232::Admin::SupplierSpreadsheet::Regions.new(@supplier_data)
        supplier_regions_spreadsheet.build

        @file_stream = Zip::OutputStream.write_buffer do |zip|
          zip.put_next_entry "RM6232 Suppliers Details (#{snapshot_date_time_string}).xlsx"
          zip.print supplier_details_spreadsheet.to_xlsx

          zip.put_next_entry "RM6232 Suppliers Services (#{snapshot_date_time_string}).xlsx"
          zip.print supplier_services_spreadsheet.to_xlsx

          zip.put_next_entry "RM6232 Suppliers Regions (#{snapshot_date_time_string}).xlsx"
          zip.print supplier_regions_spreadsheet.to_xlsx
        end

        @file_stream.rewind
      end
    end
  end
end
