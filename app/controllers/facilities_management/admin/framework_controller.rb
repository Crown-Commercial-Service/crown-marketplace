module FacilitiesManagement
  module Admin
    class FrameworkController < ::ApplicationController
      before_action :authenticate_user!
      before_action :authorize_user

      protected

      def authorize_user
        authorize! :manage, FacilitiesManagement::Admin
      end

      def rates
        @rates ||= FacilitiesManagement::Admin::Rates.all
      end

      def full_services
        services = FacilitiesManagement::Admin::StaticDataAdmin.services
        work_packages = FacilitiesManagement::Admin::StaticDataAdmin.work_packages
        work_packages_with_rates = FacilitiesManagement::Supplier::SupplierRatesHelper.add_rates_to_work_packages(work_packages, rates)
        @full_services = FacilitiesManagement::Supplier::SupplierRatesHelper.work_package_to_services(services, work_packages_with_rates)
      end

      def redirect_if_lot_out_of_range
        redirect_to facilities_management_admin_path unless ['1a', '1b', '1c'].include? @lot
      end

      def set_supplier
        @supplier = FacilitiesManagement::Admin::SuppliersAdmin.find(params[:supplier_framework_datum_id])
        @supplier_id = @supplier.supplier_id.to_sym
      end

      def set_lot
        @lot = params[:lot]
      end
    end
  end
end
