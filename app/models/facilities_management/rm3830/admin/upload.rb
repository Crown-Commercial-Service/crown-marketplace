module FacilitiesManagement
  module RM3830
    module Admin
      class Upload < FacilitiesManagement::Admin::Upload
        has_one_attached :supplier_data_file

        validates :supplier_data_file, antivirus: { message: :malicious }, size: { less_than: 10.megabytes, message: :too_large }, content_type: { with: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', message: :wrong_content_type }, on: :upload

        def self.attributes
          self::ATTRIBUTES
        end

        ATTRIBUTES = %i[supplier_data_file].freeze
        SERVICE = FacilitiesManagement::RM3830::Admin
      end
    end
  end
end
