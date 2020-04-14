require 'rubygems'

module FacilitiesManagement
  module Beta
    class BuildingsController < FacilitiesManagement::Beta::FrameworkController
      include BuildingsControllerDefinitions
      include BuildingsControllerNavigation
      include BuildingsControllerRegions

      before_action :build_page_data, only: %i[index show new create edit update gia type security add_address]

      def index; end

      def new; end

      def add_address; end

      def show; end

      def edit; end

      def gia; end

      def type; end

      def security; end

      def create
        @page_data[:model_object] = current_user.buildings.build(building_params)
        @page_data[:model_object].address_postcode = params['postcode_entry'] if @page_data[:model_object].address_postcode.blank?
        rebuild_page_data(@page_data[:model_object]) if params[:add_address].present?

        if params[:add_address].present?
          rebuild_page_description('add_address')
          render action: :add_address and return
        end

        resolve_region if params[:step] == 'add_address'
        render :new and return if params[:step] == 'add_address'

        if @page_data[:model_object].save(context: :new)

          redirect_to action: next_step[0], id: @page_data[:model_object].id
        else
          rebuild_page_data(@page_data[:model_object])
          render :new
        end
      end

      def update
        @page_data[:model_object].assign_attributes(building_params)

        render action: :add_address and return if params[:add_address].present?

        resolve_region if params[:step] == 'add_address'

        if !@page_data[:model_object].save(context: params[:step].to_sym)
          rebuild_page_description params[:step]
          render action: params[:step]
        else
          redirect_to action: :edit and return if params[:step] == 'add_address'

          redirect_to action: next_step(params[:step])[0], id: @page_data[:model_object].id and return unless params.key?('save_and_return') || next_step(params[:step]).is_a?(Hash)

          redirect_to facilities_management_beta_building_path(@page_data[:model_object].id)
        end
      end

      def destroy; end

      private

      def context_from_params
        params[:context].try(:to_sym) || params[:step].try(:to_sym)
      end

      def building_params
        params.require(:facilities_management_building)
              .permit(
                :building_name,
                :description,
                :postcode,
                :region,
                :region_code,
                :gia,
                :region,
                :building_type,
                :other_building_type,
                :security_type,
                :other_security_type,
                :address_town,
                :address_line_1,
                :address_line_2,
                :address_postcode,
                :address_region,
                :address_region_code
              )
      end

      def add_address_url
        return facilities_management_beta_building_url(@page_data[:model_object].id) if id_present?

        facilities_management_beta_buildings_path
      end

      def add_address_method
        return :patch if id_present?

        :post
      end

      def region_needs_resolution?
        return false if @page_data[:model_object].blank? || @page_data[:model_object].respond_to?(:address_postcode)

        return true if @page_data[:model_object].address_region_code.blank?

        false
      end

      def multiple_regions?
        valid_regions.length > 1
      end

      def valid_regions
        return @valid_regions ||= find_region_query_by_postcode(@page_data[:model_object].address_postcode) if @page_data[:model_object].address_postcode.present?

        []
      end

      helper_method :step_title, :step_footer, :add_address_url, :link_to_add_address, :add_address_method, :valid_regions, :region_needs_resolution?, :multiple_regions?

      def resolve_region
        return if @page_data[:model_object].blank?

        return if valid_regions.length > 1

        @page_data[:model_object].address_region = valid_regions[0]['region']
        @page_data[:model_object].address_region_code = valid_regions[0]['code']
      end

      def rebuild_page_data(building)
        @building_page_details    = @page_description = @page_definitions = nil
        @page_data[:model_object] = building

        build_page_description
      end

      def build_page_data
        @page_data                = {}
        @page_data[:model_object] = Building.find(params[:id]) if params[:id]
        @page_data[:model_object] = current_user.buildings if action_name == 'index'
        @page_data[:model_object] = Building.new if @page_data[:model_object].blank?

        build_page_description
      end

      def id_present?
        @page_data[:model_object].respond_to?(:id) && @page_data[:model_object][:id].present?
      end
    end
  end
end
