module FacilitiesManagement
  module RM6378
    module Admin
      class Upload < ::Admin::Upload
        has_one_attached :supplier_details_file
        has_one_attached :supplier_services_file
        has_one_attached :supplier_regions_file

        validates :supplier_details_file, :supplier_services_file, :supplier_regions_file, antivirus: { message: :malicious }, size: { less_than: 10.megabytes, message: :too_large }, content_type: { with: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', message: :wrong_content_type }, on: :upload

        def self.attributes
          self::ATTRIBUTES
        end

        ATTRIBUTES = %i[supplier_details_file supplier_services_file supplier_regions_file].freeze
      end
    end
  end
end
