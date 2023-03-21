module FacilitiesManagement::RM6232
  module Admin
    class ChangeLogsCsvGenerator
      COLUMN_LABELS = [
        'Log item',
        'Date of change',
        'User',
        'Supplier name',
        'Change type',
        'Changes'
      ].freeze

      CHANGE_TYPE_TO_TEXT = {
        'details' => 'Details',
        'service_codes' => 'Services',
        'region_codes' => 'Regions',
        'active' => 'Lot status'
      }.freeze

      ATTRIBUTE_TO_LABEL = {
        'active' => 'Status',
        'address_county' => 'County',
        'address_line_1' => 'Building and street',
        'address_line_2' => 'Building and street (line 2)',
        'address_postcode' => 'Postcode',
        'address_town' => 'Town or city',
        'duns' => 'DUNS number',
        'registration_number' => 'Company registration number',
        'supplier_name' => 'Supplier name'
      }.freeze

      def self.generate_csv
        CSV.generate do |csv|
          csv << COLUMN_LABELS
          audit_logs.each { |row| csv << row }
        end
      end

      def self.audit_logs
        SupplierData.order(created_at: :asc).map do |supplier_data|
          current_supplier_data = supplier_data.data

          [
            get_supplier_data_row(supplier_data)
          ] + supplier_data.edits.order(created_at: :asc).map do |edit|
            supplier = current_supplier_data.find { |supplier_item| supplier_item['id'] == edit.supplier_id }

            change_info_list = if edit.change_type == 'lot_data'
                                 change_info_list_lot_data(edit)
                               else
                                 change_info_list_detail(edit, supplier)
                               end

            get_supplier_edit_row(edit, supplier, change_info_list)
          end
        end.flatten(1).reverse
      end

      def self.get_supplier_data_row(supplier_data)
        [
          supplier_data.short_id,
          format_date_time(supplier_data.created_at),
          supplier_data.upload&.user&.email || 'During a deployment',
          'N/A',
          'Data uploaded',
          supplier_data.upload ? "Upload: #{Marketplace.rails_env_url}/facilities-management/RM6232/admin/uploads/#{supplier_data.upload.id}" : 'N/A'
        ]
      end

      def self.get_supplier_edit_row(edit, supplier, change_info_list)
        [
          edit.short_id,
          format_date_time(edit.created_at),
          edit.user.email,
          supplier['supplier_name'],
          CHANGE_TYPE_TO_TEXT[edit.true_change_type],
          change_info_list.join("\n")
        ]
      end

      def self.change_info_list_lot_data(edit)
        change_info_list = ["Lot code: #{edit.data['lot_code']}"]

        if edit.data['attribute'] == 'active'
          old_value = get_attribute_value('active', edit.data['removed'])
          new_value = get_attribute_value('active', edit.data['added'])

          change_info_list << "Lot status - FROM: #{old_value} TO: #{new_value}"
        else
          ['added', 'removed'].each { |change| change_info_list << "#{change.capitalize} items: #{item_names(edit.data['attribute'], edit.data[change])}" if edit.data[change].any? }
        end

        change_info_list
      end

      def self.change_info_list_detail(edit, supplier)
        edit.data.map do |detail|
          old_value = get_attribute_value(detail['attribute'], supplier[detail['attribute']])
          new_value = get_attribute_value(detail['attribute'], detail['value'])

          supplier[detail['attribute']] = detail['value']

          "#{ATTRIBUTE_TO_LABEL[detail['attribute']]} - FROM: #{old_value} TO: #{new_value}"
        end
      end

      def self.format_date_time(date_object)
        date_object.in_time_zone('London').strftime('%d/%m/%Y %H:%M').squish
      end

      def self.service_codes_with_name
        @service_codes_with_name ||= FacilitiesManagement::RM6232::Service.order(:work_package_code, :sort_order).to_h { |service| [service.code, "#{service.code} #{service.name}"] }
      end

      def self.region_codes_with_name
        @region_codes_with_name ||= FacilitiesManagement::Region.all.to_h { |region| [region.code, "#{region.code} #{region.name}"] }
      end

      def self.item_names(attribute, codes)
        case attribute
        when 'region_codes'
          region_codes_with_name.slice(*codes).values
        when 'service_codes'
          service_codes_with_name.slice(*codes).values
        end.join('|')
      end

      def self.get_attribute_value(attribute, value)
        return value unless attribute == 'active'

        value || value.nil? ? 'Active' : 'Inactive'
      end
    end
  end
end
