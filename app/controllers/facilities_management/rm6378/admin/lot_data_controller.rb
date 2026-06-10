module FacilitiesManagement
  module RM6378
    module Admin
      class LotDataController < FacilitiesManagement::Admin::FrameworkController
        include ::Admin::LotDataActions

        LOT_SORT_CRITERIA = 'lots.number'.freeze

        SECTIONS_TO_SHOW = %i[services jurisdictions].freeze
        SECTIONS_TO_EDIT = %i[lot_status services jurisdictions].freeze

        private

        def lot_sections(_lot)
          %i[services jurisdictions]
        end

        def set_section_data
          case @section
          when :services
            @services = super.map { |group, services| [I18n.t("facilities_management.rm6378.journey.choose_services.services.section.#{group}.title"), services] }
          when :jurisdictions
            @jurisdictions = Jurisdiction.regions_grouped_by_category.map { |group, jurisdictions| [I18n.t("facilities_management.rm6378.journey.choose_locations.regions.section.#{group}.title"), jurisdictions] }
          end
        end
      end
    end
  end
end
