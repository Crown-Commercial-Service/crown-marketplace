module FacilitiesManagement
  module Admin
    class SupplierDetailsController < FacilitiesManagement::Admin::FrameworkController
      before_action :set_framework_has_expired
      before_action :redirect_if_framework_has_expired, only: %i[edit update]
      before_action :set_data_for_framework
      before_action :set_supplier
      before_action :set_page, only: %i[edit update]
      before_action :set_user_email, only: :edit, if: -> { @page == :supplier_user }

      rescue_from ActiveRecord::RecordNotFound do
        redirect_to(if @framework == 'RM3830'
                      facilities_management_rm3830_admin_supplier_details_path
                    else
                      facilities_management_rm6232_admin_supplier_data_path
                    end)
      end

      def show; end

      def edit; end

      def update
        @supplier.assign_attributes(supplier_params)

        if @supplier.save(context: @page)
          FacilitiesManagement::RM6232::Admin::SupplierData::Edit.log_change(current_user, @supplier) if @framework == 'RM6232'
          redirect_to facilities_management_admin_supplier_detail_path
        else
          render :edit
        end
      end

      private

      def set_data_for_framework
        @framework = params[:framework]
        @suppliers_admin_module = SUPPLIER_ADMIN_MODULES[@framework]
        @suppliers_admin_param_key = @suppliers_admin_module.model_name.param_key
      end

      def set_supplier
        @supplier = @suppliers_admin_module.find(params[:id])
      end

      def set_page
        @page = params[:page].to_sym
      end

      def set_user_email
        @supplier.user_email = @supplier.user&.email
      end

      def supplier_params
        params.expect(@suppliers_admin_param_key => PERMITED_PARAMS[@page])
      end

      def redirect_if_framework_has_expired
        redirect_to facilities_management_admin_supplier_detail_path if @framework_has_expired
      end

      PERMITED_PARAMS = {
        supplier_name: %i[supplier_name],
        supplier_contact_information: %i[contact_name contact_email contact_phone],
        additional_supplier_information: %i[duns registration_number],
        supplier_address: %i[address_line_1 address_line_2 address_town address_county address_postcode],
        supplier_user: %i[user_email],
        supplier_status: %i[active]
      }.freeze

      SUPPLIER_ADMIN_MODULES = {
        'RM3830' => FacilitiesManagement::RM3830::Admin::SuppliersAdmin,
        'RM6232' => FacilitiesManagement::RM6232::Admin::SuppliersAdmin
      }.freeze
    end
  end
end
