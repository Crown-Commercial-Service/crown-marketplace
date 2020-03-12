module FacilitiesManagement::Beta::Supplier::SupplierRatesHelper
  def self.add_rates_to_work_packages(work_packages, rates)
    work_packages_with_rates = []
    work_packages.each do |work_package|
      work_package['rates'] = rates.select { |key| key['code'] == work_package['code'] }
      work_packages_with_rates.push(work_package)
    end
  end

  def self.work_package_to_services(services, work_packages)
    full_services = []
    services.each do |service|
      service['work_package'] = work_packages.select { |key| key['work_package_code'] == service['code'] }

      service['standard_a'] = service['work_package'][0]['rates'].select { |key| key.standard == 'A' }
      service['standard_b'] = service['work_package'][0]['rates'].select { |key| key.standard == 'B' }
      service['standard_c'] = service['work_package'][0]['rates'].select { |key| key.standard == 'C' }

      service['value_type'] = service['code'] == 'M' || service['code'] == 'N' ? 'percentage' : 'money'

      full_services.push(service)
    end
  end
end
