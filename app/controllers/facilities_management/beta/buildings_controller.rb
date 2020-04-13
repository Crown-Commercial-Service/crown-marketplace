require 'rubygems'

module FacilitiesManagement
  module Beta
    # rubocop:disable Metrics/MethodLength
    class BuildingsController < FacilitiesManagement::Beta::FrameworkController
      before_action :build_page_data, only: %i[index show new create edit update gia type security add_address]
      # rubocop:disable Metrics/AbcSize

      def index; end

      def new; end

      def add_address; end

      def show; end

      def edit; end

      def gia; end

      def type; end

      def security; end

      def create
        new_building = current_user.buildings.build(building_params)

        if new_building.save(context: :new)
          redirect_to action: next_step[0], id: new_building.id
        else
          rebuild_page_data(new_building)
          render :new
        end
      end

      # rubocop:disable Style/AndOr
      def update
        @page_data[:model_object].assign_attributes(building_params)

        if !@page_data[:model_object].save(context: context_from_params)
          rebuild_page_description params[:step]
          render action: params[:step]
        else
          redirect_to action: :edit and return if context_from_params == :update_address

          redirect_to action: next_step(params[:step])[0], id: @page_data[:model_object].id and return unless params.key?('save_and_return') || next_step(params[:step]).is_a?(Hash)

          redirect_to facilities_management_beta_building_path(@page_data[:model_object].id)
        end
      end
      # rubocop:enable Style/AndOr

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

      def redirect_to_return_url
        redirect_details = Rack::Utils.parse_nested_query(params['facilities_management_building']['return_details'])
        redirect_path = redirect_details['url']
        redirect_params = redirect_details['params']

        redirect_to("#{redirect_path}?#{redirect_params.to_query}") && return if redirect_path.present?

        false
      end

      STEPS = {
        create: { position: 1, desc: '' },
        new: { position: 1, desc: '' },
        add_address: { position: 1, desc: '' },
        edit: { position: 1, desc: '' },
        update: { position: 1, desc: '' },
        gia: { position: 2, desc: 'What\'s the internal area of the building?' },
        type: { position: 3, desc: 'Choose the building type that best describes your building' },
        security: { position: 4, desc: 'Select the level of security clearance needed' }
      }.freeze

      def step_title
        t('facilities_management.beta.buildings.step_title.step_title', position: STEPS.dig(action_name.to_sym, :position), total: maximum_step_number)
      end

      def step_footer
        t('facilities_management.beta.buildings.step_footer.step_footer', description: next_step[1][:desc]) if STEPS.dig(action_name.to_sym, :position).to_i < maximum_step_number
      end

      def maximum_step_number
        @maximum_step_number ||= STEPS.max_by { |_k, v| v[:position] }[1][:position]
      end

      def next_step(step = action_name)
        return STEPS.select { |_k, step_value| step_value[:position] == (STEPS.dig(step.to_sym, :position).to_i + 1) }.first if STEPS.dig(step.to_sym, :position).to_i < maximum_step_number

        STEPS[:edit]
      end

      def add_address_url
        return facilities_management_beta_building_url(@page_data[:model_object].id, context: :update_address) if id_present?

        facilities_management_beta_building_path(context: :update_address)
      end

      def add_address_method
        return :patch if id_present?

        :post
      end

      def link_to_add_address
        return add_address_facilities_management_beta_building_path(@page_data[:model_object].id, update_address: true) if id_present?

        facilities_management_beta_buildings_new_add_address_path(update_address: true)
      end

      helper_method :step_title, :step_footer, :add_address_url, :link_to_add_address, :add_address_method

      def rebuild_page_data(building)
        @building_page_details    = @page_description = nil
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

      def rebuild_page_description(step)
        @building_page_details = @page_description = nil
        build_page_description step
      end

      def build_page_description(step = action_name)
        action = case step
                 when 'create'
                   'new'
                 when 'update'
                   'edit'
                 else
                   step
                 end
        page_description action
      end

      def page_description(action = action_name)
        @page_description ||= LayoutHelper::PageDescription.new(
          LayoutHelper::HeadingDetail.new(building_page_details(action)[:page_title],
                                          building_page_details(action)[:caption1],
                                          building_page_details(action)[:caption2],
                                          building_page_details(action)[:sub_title],
                                          building_page_details(action)[:caption3]),
          LayoutHelper::BackButtonDetail.new(building_page_details(action)[:back_url],
                                             building_page_details(action)[:back_label],
                                             building_page_details(action)[:back_text]),
          LayoutHelper::NavigationDetail.new(building_page_details(action)[:continuation_text],
                                             building_page_details(action)[:return_url],
                                             building_page_details(action)[:return_text],
                                             building_page_details(action)[:secondary_url],
                                             building_page_details(action)[:secondary_text],
                                             building_page_details(action)[:continuation_name],
                                             building_page_details(action)[:secondary_name],
                                             building_page_details(action)[:continuation_url])
        )
      end

      def building_page_details(action)
        @building_page_details ||= if page_definitions.key?(action.to_sym)
                                     page_definitions[:default].merge(page_definitions[action.to_sym])
                                   else
                                     page_definitions[:default]
                                   end
      end

      def id_present?
        @page_data[:model_object].respond_to?(:id) && @page_data[:model_object][:id].present?
      end

      # rubocop:disable Metrics/MethodLength, CyclomaticComplexity, PerceivedComplexity
      def page_definitions
        @page_definitions ||= {
          default: {
            continuation_text: I18n.t('facilities_management.beta.buildings.page_definitions.create_new_building'),
            continuation_url: new_facilities_management_beta_building_url,
            secondary_name: 'return_to_buildings',
            secondary_text: I18n.t('facilities_management.beta.buildings.page_definitions.return_to_manage_buildings'),
            secondary_url: facilities_management_beta_buildings_path,
            back_text: 'Back',
            back_url: facilities_management_beta_buildings_path
          },
          index: {
            page_title: I18n.t('facilities_management.beta.buildings.page_definitions.manage_building_title'),
            back_url: facilities_management_beta_path
          },
          new: {
            caption1: I18n.t('facilities_management.beta.buildings.page_definitions.manage_building_title'),
            caption3: step_title,
            page_title: I18n.t('facilities_management.beta.buildings.page_definitions.create_single_building')
          },
          add_address: {
            caption1: I18n.t('facilities_management.beta.buildings.page_definitions.manage_building_title'),
            caption2: (@page_data[:model_object]&.building_name if @page_data[:model_object].respond_to? :building_name),
            caption3: step_title,
            page_title: I18n.t('facilities_management.beta.buildings.page_definitions.add_building_address'),
            continuation_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_continue'),
            back_url: if id_present?
                        edit_facilities_management_beta_building_path(@page_data[:model_object])
                      else
                        (new_facilities_management_beta_building_path)
                      end
          },
          edit: {
            caption1: I18n.t('facilities_management.beta.buildings.page_definitions.manage_building_title'),
            caption2: (@page_data[:model_object]&.building_name if @page_data[:model_object].respond_to? :building_name),
            caption3: step_title,
            page_title: I18n.t('facilities_management.beta.buildings.page_definitions.change_building_details'),
            continuation_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_continue'),
            secondary_name: 'save_and_return',
            secondary_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_return_to_detailed_summary'),
            back_url: (facilities_management_beta_building_path(@page_data[:model_object].id) if id_present?),
          },
          show: {
            continuation_text: I18n.t('facilities_management.beta.buildings.page_definitions.return_to_manage_buildings'),
            continuation_url: facilities_management_beta_buildings_url,
            caption1: I18n.t('facilities_management.beta.buildings.page_definitions.manage_building_title'),
            page_title: (@page_data[:model_object]&.building_name if @page_data[:model_object].respond_to? :building_name),
          },
          gia: {
            caption1: I18n.t('facilities_management.beta.buildings.page_definitions.manage_building_title'),
            caption2: (@page_data[:model_object]&.building_name if @page_data[:model_object].respond_to? :building_name),
            caption3: step_title,
            page_title: I18n.t('facilities_management.beta.buildings.page_definitions.building_size'),
            continuation_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_continue'),
            secondary_name: 'save_and_return',
            secondary_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_return_to_detailed_summary'),
            return_url: (type_facilities_management_beta_building_path(@page_data[:model_object].id) if id_present?),
            return_text: I18n.t('facilities_management.beta.buildings.page_definitions.skip_this_step'),
            back_url: (edit_facilities_management_beta_building_path(@page_data[:model_object].id) if id_present?),
          },
          type: {
            caption1: I18n.t('facilities_management.beta.buildings.page_definitions.manage_building_title'),
            caption2: (@page_data[:model_object]&.building_name if @page_data[:model_object].respond_to? :building_name),
            caption3: step_title,
            page_title: I18n.t('facilities_management.beta.buildings.page_definitions.building_type'),
            continuation_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_continue'),
            secondary_name: 'save_and_return',
            secondary_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_return_to_detailed_summary'),
            return_url: (security_facilities_management_beta_building_path(@page_data[:model_object].id) if id_present?),
            return_text: I18n.t('facilities_management.beta.buildings.page_definitions.skip_this_step'),
            back_url: (gia_facilities_management_beta_building_path(@page_data[:model_object].id) if id_present?),
          },
          security: {
            caption1: I18n.t('facilities_management.beta.buildings.page_definitions.manage_building_title'),
            caption2: (@page_data[:model_object]&.building_name if @page_data[:model_object].respond_to? :building_name),
            caption3: step_title,
            page_title: I18n.t('facilities_management.beta.buildings.page_definitions.security_clearance'),
            continuation_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_return_to_detailed_summary'),
            continuation_name: 'save_and_return',
            secondary_name: 'save_and_return',
            secondary_text: I18n.t('facilities_management.beta.buildings.page_definitions.save_and_return_to_detailed_summary'),
            return_url: facilities_management_beta_buildings_url,
            return_text: I18n.t('facilities_management.beta.buildings.page_definitions.skip_this_step'),
            back_url: (type_facilities_management_beta_building_path(@page_data[:model_object].id) if id_present?)
          }
        }.freeze
      end
      # rubocop:enable Metrics/MethodLength, CyclomaticComplexity, PerceivedComplexity, Metrics/AbcSize
    end
    # rubocop:enable Metrics/MethodLength
  end
end
