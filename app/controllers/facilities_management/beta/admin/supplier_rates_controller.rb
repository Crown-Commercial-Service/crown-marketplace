module FacilitiesManagement
  module Beta
    module Admin
      class SupplierRatesController < FacilitiesManagement::Beta::FrameworkController
        def supplier_benchmark_rates
          @rates = FacilitiesManagement::Admin::Rates.all
          @services = FacilitiesManagement::Admin::StaticDataAdmin.services
          @work_packages = FacilitiesManagement::Admin::StaticDataAdmin.work_packages
          @work_packages_with_rates = FacilitiesManagement::Beta::Supplier::SupplierRatesHelper.add_rates_to_work_packages(@work_packages, @rates)
          @full_services = FacilitiesManagement::Beta::Supplier::SupplierRatesHelper.work_package_to_services(@services, @work_packages_with_rates)
        end

        def supplier_framework_rates
          @rates = FacilitiesManagement::Admin::Rates.all
          @services = FacilitiesManagement::Admin::StaticDataAdmin.services
          @work_packages = FacilitiesManagement::Admin::StaticDataAdmin.work_packages
          @work_packages_with_rates = FacilitiesManagement::Beta::Supplier::SupplierRatesHelper.add_rates_to_work_packages(@work_packages, @rates)
          @full_services = FacilitiesManagement::Beta::Supplier::SupplierRatesHelper.work_package_to_services(@services, @work_packages_with_rates)
        end
      end
    end
  end
end
