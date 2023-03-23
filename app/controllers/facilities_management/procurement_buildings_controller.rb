module FacilitiesManagement
  class ProcurementBuildingsController < FacilitiesManagement::FrameworkController
    before_action :set_procurement_building_data, except: :missing_regions
    before_action :set_procurement_data, only: :missing_regions
    before_action :authorize_user
    before_action :redirect_if_unrecognised_stection, only: :edit

    helper_method :procurement_index_path, :procurement_show_path, :update_path, :section

    def edit; end

    def update
      case section
      when :buildings_and_services
        update_procurement_building
      when :missing_region
        update_missing_region
      end
    end

    # rubocop:disable Rails/I18nLazyLookup
    def missing_regions
      redirect_to procurement_show_path unless @procurement.procurement_buildings_missing_regions?

      @back_path = procurement_index_path
      @back_text = t('facilities_management.procurement_buildings.missing_regions.return_to_dashboard')
    end
    # rubocop:enable Rails/I18nLazyLookup

    private

    def procurement_index_path
      "/facilities-management/#{params[:framework]}/procurements"
    end

    def procurement_show_path
      "/facilities-management/#{params[:framework]}/procurements/#{@procurement.id}"
    end

    def update_path
      "/facilities-management/#{params[:framework]}/procurement-buildings/#{params[:id]}/#{section.to_s.dasherize}"
    end

    def procurement_details_show_path
      "/facilities-management/#{params[:framework]}/procurements/#{@procurement.id}/procurement-details/buildings-and-services"
    end

    def update_missing_region
      @building.assign_attributes(building_params)
      @building.add_region_code_from_address_region

      if @building.save(context: :all)
        redirect_to procurement_show_path
      else
        render :edit
      end
    end

    def update_procurement_building
      @procurement_building.assign_attributes(procurement_building_params)

      if @procurement_building.save(context: :buildings_and_services)
        redirect_to procurement_details_show_path
      else
        render :edit
      end
    end

    def building_params
      params.require(:facilities_management_building)
            .permit(:address_region)
    end

    def procurement_building_params
      params.require(@procurement_building.model_name.param_key)
            .permit(service_codes: [])
    end

    def set_procurement_building_data
      @procurement = @procurement_building.procurement
      @building = @procurement_building.building
    end

    def section
      @section ||= params[:section].underscore.to_sym
    end

    def redirect_if_unrecognised_stection
      redirect_to procurement_show_path unless RECOGNISED_SECTIONS.include? section
    end

    RECOGNISED_SECTIONS = %i[buildings_and_services missing_region].freeze

    protected

    def authorize_user
      authorize! :manage, @procurement
    end
  end
end
