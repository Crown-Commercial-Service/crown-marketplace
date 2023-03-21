module FacilitiesManagement
  class BuildingsController < FacilitiesManagement::FrameworkController
    include FacilitiesManagement::FindAddressConcern

    before_action :set_procurement, if: -> { params[:procurement_id] }
    before_action :set_building, only: %i[show edit update]
    before_action :authorize_user
    before_action :redirect_if_unrecognised_edit_section, only: %i[edit update]
    before_action :set_edit_back_path, only: :edit
    before_action :set_new_back_path, only: :new

    helper_method :index_path, :new_path, :show_path, :edit_path, :create_path, :update_path, :start_a_procurement_path, :section, :next_step_path, :last_step?, :valid_regions

    def index
      @buildings = current_user.buildings.order_by_building_name.page(params[:page])
    end

    # rubocop:disable Rails/I18nLazyLookup
    def show
      @back_text = t('facilities_management.buildings.show.return_to_buildings')
      @back_path = index_path
    end
    # rubocop:enable Rails/I18nLazyLookup

    def new
      @building = current_user.buildings.build
    end

    def edit; end

    def create
      @section = :building_details

      @building = current_user.buildings.build(building_params)

      if params[:add_address].present?
        add_address
      elsif @building.save(context: :new)
        redirect_to(params[:save_and_return] ? show_path : next_step_path)
      else
        set_new_back_path
        render :new
      end
    end

    def update
      @building.assign_attributes(building_params)

      if @building.save(context: section)
        resolve_region(true) if add_address?
        redirect_to(params[:save_and_return] ? show_path : next_step_path)
      else
        set_edit_back_path
        render :edit
      end
    end

    private

    def set_building
      @building = Building.find(params[:id])
    end

    def section
      @section ||= params[:section]&.to_sym
    end

    def redirect_if_unrecognised_edit_section
      redirect_to show_path unless RECOGNISED_EDIT_SECTIONS.include? section
    end

    RECOGNISED_EDIT_SECTIONS = %i[building_details building_area building_type security_type add_address].freeze

    def set_edit_back_path
      @back_text = t("facilities_management.buildings.edit.previous_step_back_text.#{section}")
      @back_path = previous_step_path
    end

    def set_new_back_path
      @back_text = t('facilities_management.buildings.new.return_to_buildings')
      @back_path = index_path
    end

    def current_step_index
      @current_step_index ||= RECOGNISED_EDIT_SECTIONS.index(section)
    end

    def previous_step_path
      if current_step_index.zero?
        show_path
      else
        previous_step = add_address? ? :building_details : RECOGNISED_EDIT_SECTIONS[current_step_index - 1]

        edit_path(@building, previous_step)
      end
    end

    def next_step_path
      if last_step?
        add_address? ? edit_path(@building, :building_details) : show_path
      else
        edit_path(@building, RECOGNISED_EDIT_SECTIONS[current_step_index + 1])
      end
    end

    def last_step?
      @last_step ||= current_step_index > 2
    end

    def add_address?
      section == :add_address
    end

    def add_address
      if params[:step] && @building.valid?(:add_address)
        resolve_region(false)
        set_new_back_path
        render :new
      else
        render_add_address
      end
    end

    def render_add_address
      @back_text = t('facilities_management.buildings.add_address.return_to_building_details')
      @back_path = 'javascript:history.back()'
      render :add_address
    end

    def building_params
      if params[:facilities_management_building]
        params.require(:facilities_management_building).permit(PERMITED_PARAMS[section])
      else
        {}
      end
    end

    PERMITED_PARAMS = {
      building_details: %i[building_name description address_line_1 address_line_2 address_town address_postcode address_region address_region_code],
      building_area: %i[gia external_area],
      building_type: %i[building_type other_building_type],
      security_type: %i[security_type other_security_type],
      add_address: %i[address_line_1 address_line_2 address_town address_postcode]
    }.freeze

    # Methods relating to the building address
    def valid_regions
      return @valid_regions ||= find_region_query_by_postcode(@building.address_postcode) if @building.address_postcode.present?

      []
    end

    def resolve_region(save_region)
      return if @building.blank?

      return if valid_regions.length > 1 || valid_regions.empty?

      @building.address_region = valid_regions[0][:region]
      @building.address_region_code = valid_regions[0][:code]
      @building.save if save_region
    end

    protected

    def authorize_user
      @procurement ? (authorize! :manage, @procurement) : (authorize! :read, FacilitiesManagement)
      @building.present? ? (authorize! :manage, @building) : (authorize! :read, FacilitiesManagement)
    end
  end
end
