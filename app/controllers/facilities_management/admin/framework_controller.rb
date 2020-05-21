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
    end
  end
end
