module FacilitiesManagement::RM6232::Admin::ChangeLogsHelper
  def show_page_title
    @show_page_title ||= t("facilities_management.rm6232.admin.change_logs.show.heading.#{@change_log.true_change_type}")
  end

  def item_names(codes)
    case @change_log.data['attribute']
    when 'region_codes'
      FacilitiesManagement::Region.where(code: codes).map { |region| "#{region.name} (#{region.code})" }
    when 'service_codes'
      FacilitiesManagement::RM6232::Service.where(code: codes).order(:work_package_code, :sort_order).map { |service| "#{service.code} #{service.name}" }
    end
  end

  def get_attribute_value(attribute, value)
    return value unless attribute == 'active'

    govuk_tag(*if value || value.nil?
                 ['ACTIVE']
               else
                 ['INACTIVE', :red]
               end)
  end
end
