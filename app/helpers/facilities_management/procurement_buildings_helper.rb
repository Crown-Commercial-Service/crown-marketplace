module FacilitiesManagement::ProcurementBuildingsHelper
  def edit_page_title
    section == :missing_region ? t('facilities_management.procurement_buildings.edit.title.missing_region') : building_name
  end

  def building_name(procurement_building = @procurement_building)
    procurement_building.building_name || procurement_building.name
  end

  def building_summary(title, vlaue)
    tag.div(class: 'govuk-grid-row govuk-!-margin-bottom-6') do
      tag.div(class: 'govuk-grid-column-two-thirds') do
        capture do
          concat(tag.h3(title, class: 'govuk-heading-s govuk-!-margin-bottom-2'))
          concat(tag.span(vlaue, class: 'govuk-body'))
        end
      end
    end
  end

  def regions
    Postcode::PostcodeCheckerV2.find_region(@building.address_postcode.delete(' ')).pluck(:region)
  end

  def form_object
    section == :missing_region ? @building : @procurement_building
  end

  def buildings_with_missing_regions
    @buildings_with_missing_regions ||= @procurement.active_procurement_buildings.order_by_building_name.select(&:missing_region?)
  end

  def return_link
    section == :missing_region ? procurement_show_path : "/facilities-management/#{params[:framework]}/procurements/#{@procurement.id}/procurement-details/buildings-and-services"
  end
end
