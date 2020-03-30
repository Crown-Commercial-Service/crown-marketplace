require 'rubygems'

module FacilitiesManagement
  module Beta
    class BuildingsController < FacilitiesManagement::Beta::FrameworkController
      before_action :build_page_data, only: %i[index show new edit update destroy]

      def index; end

      def new; end

      def show; end

      def edit; end

      def update
        render :edit
      end

      def destroy; end

      private

      STEPS = {
        new: { position: 1, desc: "What's the internal area of the building?"},
        gia: {position: 2, desc: ''}, type: { position: 3, desc: ''}, security_type: {position: 4, desc:''}
      }.freeze

      def step_title
        t('.step_title', position: STEPS.dig(action_name.to_sym, :position))
      end

      def step_footer
        t('.step_footer', description: STEPS.dig(action_name.to_sym, :desc))
      end
      helper_method :step_title, :step_footer

      def build_page_data
        @page_data                = {}
        @page_data[:model_object] = Buildings.find(params[:id]) if params[:id]
        @page_data[:model_object] = Buildings.buildings_for_user(current_user.email.to_s) if  action_name == 'index'
        @page_data[:model_object] = FacilitiesManagement::Buildings.new if @page_data[:model_object].blank?

        page_description
      end

      # rubocop:disable Metrics/AbcSize
      def page_description
        @page_description ||= LayoutHelper::PageDescription.new(
          LayoutHelper::HeadingDetail.new(building_page_details(action_name)[:page_title],
                                          building_page_details(action_name)[:caption1],
                                          building_page_details(action_name)[:caption2],
                                          building_page_details(action_name)[:sub_title],
                                          building_page_details(action_name)[:caption3]),
          LayoutHelper::BackButtonDetail.new(building_page_details(action_name)[:back_url],
                                             building_page_details(action_name)[:back_label],
                                             building_page_details(action_name)[:back_text]),
          LayoutHelper::NavigationDetail.new(building_page_details(action_name)[:continuation_text],
                                             building_page_details(action_name)[:return_url],
                                             building_page_details(action_name)[:return_text],
                                             building_page_details(action_name)[:secondary_url],
                                             building_page_details(action_name)[:secondary_text],
                                             building_page_details(action_name)[:primary_name],
                                             building_page_details(action_name)[:secondary_name],
                                             building_page_details(action_name)[:continuation_url])
        )
      end

      def building_page_details(action)
        @building_page_details ||= page_definitions[:default].merge(page_definitions[action.to_sym])
      end

      def page_definitions
        @page_definitions ||= {
          default: {
            continuation_text: t('.create_new_building'),
            continuation_url: new_facilities_management_beta_building_url,
            secondary_name: 'return_to_buildings',
            secondary_text: t('.return_to_manage_buildings'),
            secondary_url: facilities_management_beta_buildings_url,
            back_text: 'Back',
            back_url: facilities_management_beta_buildings_path
          },
          index: {
            page_title: t('.manage_building_title'),
            back_url: facilities_management_beta_path
          },
          new: {
            caption1: t('.manage_building_title'),
            caption3: step_title,
            page_title: t('.create_single_building')
          },
          show: {
            caption1: t('.manage_building_title'),
            page_title: (@page_data[:model_object]&.building_name if @page_data[:model_object].respond_to? :building_name),
          },
          edit: {
            caption1: t('.manage_building_title'),
            page_title: t('.change_building_details')
          }
        }.freeze
      end
      # rubocop:enable Metrics/AbcSize
    end
  end
end
