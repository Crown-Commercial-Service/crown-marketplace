module FacilitiesManagement
  module Beta
    module Admin
      class SublotDataServicesPricesController < FacilitiesManagement::Beta::FrameworkController
        def index
          @list_service_types = ['Discount award discount (%)', 'General office - customer facing (£)', 'General office non - customer facing (£)', 'Call centre operations (£)', 'Warehouses (£)', 'Restaurant and catering facilities (£)', 'Pre-school (£)', 'Primary (£)', 'Secondary schools (£)', 'Special schools (£)', 'Universities and colleges (£)', 'Community - doctors, dentists, health clinic (£)', 'Nursing and care homes (£)']

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
