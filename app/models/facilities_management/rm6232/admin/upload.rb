module FacilitiesManagement
  module RM6232
    module Admin
      class Upload < FacilitiesManagement::Admin::Upload
        has_one_attached :supplier_details_file
        has_one_attached :supplier_services_file
        has_one_attached :supplier_regions_file

        validates :supplier_details_file, :supplier_services_file, :supplier_regions_file, antivirus: { message: :malicious }, size: { less_than: 10.megabytes, message: :too_large }, content_type: { with: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', message: :wrong_content_type }, on: :upload

        def self.attributes
          self::ATTRIBUTES
        end

        ATTRIBUTES = %i[supplier_details_file supplier_services_file supplier_regions_file].freeze
        SERVICE = FacilitiesManagement::RM6232::Admin
      end
    end
  end
end
