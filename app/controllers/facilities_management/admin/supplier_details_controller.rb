module FacilitiesManagement
  module Admin
    class SupplierDetailsController < FacilitiesManagement::Admin::FrameworkController
      before_action :set_supplier, except: :index
      before_action :set_page, only: %i[edit update]
      before_action :set_user_email, only: :edit, if: -> { @page == :supplier_user }

      def index
        @suppliers = FacilitiesManagement::Admin::SuppliersAdmin.select(:supplier_id, :supplier_name, :contact_email).order(:supplier_name)
      end

      def show; end

      def edit; end

      def update
        @supplier.assign_attributes(supplier_params)

        if @supplier.save(context: @page)
          redirect_to facilities_management_admin_supplier_detail_path
        else
          render :edit
        end
      end

      private

      def set_supplier
        @supplier = FacilitiesManagement::Admin::SuppliersAdmin.find(params[:id])
      end

      def set_page
        @page = params[:page].to_sym
      end

      def set_user_email
        @supplier.user_email = @supplier.user&.email
      end

      def supplier_params
        params.require(:facilities_management_admin_suppliers_admin).permit(permitted_params)
      end

      def permitted_params
        case @page
        when :supplier_name
          %i[supplier_name]
        when :supplier_contact_information
          %i[contact_name contact_email contact_phone]
        when :additional_supplier_information
          %i[duns registration_number]
        when :supplier_address
          %i[address_line_1 address_line_2 address_town address_county address_postcode]
        when :supplier_user
          %i[user_email]
        end
      end
    end
  end
end
