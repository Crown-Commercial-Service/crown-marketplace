module FM::RM6232
  module GenerateSuppliers
    def self.truncate_tables
      FacilitiesManagement::RM6232::Supplier::LotData.destroy_all
      FacilitiesManagement::RM6232::Supplier.destroy_all
    end

    def self.generate_suppliers
      50.times do
        FacilitiesManagement::RM6232::Supplier.create(supplier_name: Faker::Company.unique.name)
      end

      suppliers = FacilitiesManagement::RM6232::Supplier.all
      suppliers.shuffle

      lot_groups = [{ suppliers: suppliers[0..24], lot_numbers: ['1a', '1b', '2a', '3a'] }, { suppliers: suppliers[15..35], lot_numbers: ['1c', '2b', '3b'] }, { suppliers: suppliers[25..51], lot_numbers: ['1d', '2c', '3c'] }]

      lot_groups.each do |lot_group|
        lot_group[:lot_numbers].each do |lot_number|
          all_services_and_regions(lot_group[:suppliers][..4], lot_number)
          all_services_england_and_wales(lot_group[:suppliers][5..9], lot_number)
          random_services_and_regions(lot_group[:suppliers][10..], lot_number)
        end
      end
    end

    def self.total_fm_services
      @total_fm_services ||= FacilitiesManagement::RM6232::WorkPackage.selectable.map { |wp| [wp.code, wp.services.where(total: true).pluck(:code)] }.to_h
    end

    def self.hard_fm_services
      @hard_fm_services ||= FacilitiesManagement::RM6232::WorkPackage.selectable.map { |wp| [wp.code, wp.services.where(hard: true).pluck(:code)] }.to_h
    end

    def self.soft_fm_services
      @soft_fm_services ||= FacilitiesManagement::RM6232::WorkPackage.selectable.map { |wp| [wp.code, wp.services.where(soft: true).pluck(:code)] }.to_h
    end

    def self.all_services(lot_number)
      work_packages = if lot_number.starts_with?('1')
                        total_fm_services
                      elsif lot_number.starts_with?('2')
                        hard_fm_services
                      else
                        soft_fm_services
                      end
      work_packages.values.flatten
    end

    def self.all_services_and_regions(suppliers, lot_number)
      service_codes = all_services(lot_number)
      region_codes = regions.map { |_, codes| codes }.flatten

      suppliers.each do |supplier|
        supplier.lot_data.create(lot_number: lot_number, service_codes: service_codes, region_codes: region_codes, sector_codes: sectors)
      end
    end

    def self.all_services_england_and_wales(suppliers, lot_number)
      service_codes = all_services(lot_number)
      region_codes = regions.reject { |region, _| ['UKM', 'UKN'].include? region }.map { |_, codes| codes }.flatten

      suppliers.each do |supplier|
        supplier.lot_data.create(lot_number: lot_number, service_codes: service_codes, region_codes: region_codes, sector_codes: sectors)
      end
    end

    def self.random_services_and_regions(suppliers, lot_number)
      all_service_codes = all_services(lot_number)
      service_count = all_service_codes.size / 2

      random_service_codes = all_service_codes.sample(service_count)
      random_service_codes += ['P.1'] if lot_number == 3
      random_service_codes += ['P.2', 'Q.1', 'R.1']

      random_service_codes = sorted_service_codes(random_service_codes.uniq)

      random_region_codes = regions.map { |_, codes| codes }.flatten.sample(35).sort

      suppliers.each do |supplier|
        supplier.lot_data.create(lot_number: lot_number, service_codes: random_service_codes, region_codes: random_region_codes, sector_codes: sectors.sample(4).sort)
      end
    end

    def self.regions
      @regions ||= FacilitiesManagement::Region.all.reject { |region| region.code == 'OS01' }.map(&:code).group_by { |region_code| region_code[..2] }
    end

    def self.sectors
      @sectors ||= FacilitiesManagement::RM6232::Sector.pluck(:id)
    end

    def self.sorted_service_codes(service_codes)
      service_codes.sort_by { |service_code| all_service_codes_sorted.index(service_code) }
    end

    def self.all_service_codes_sorted
      @all_service_codes_sorted ||= FacilitiesManagement::RM6232::Service.order(:work_package_code, :sort_order).pluck(:code)
    end

    def self.convert_to_json
      dummy_supplier_data = FacilitiesManagement::RM6232::Supplier.all.order(:supplier_name).map do |supplier|
        lot_data = supplier.lot_data.order(:lot_number).map do |data|
          {
            lot_number: data.lot_number,
            service_codes: data.service_codes,
            region_codes: data.region_codes,
            sector_codes: data.sector_codes
          }
        end

        {
          id: supplier.id,
          supplier_name: supplier.supplier_name,
          lot_data: lot_data
        }
      end

      File.open('data/facilities_management/rm6232/dummy_supplier_data.json', 'w') { |file| file.write(JSON.pretty_generate(dummy_supplier_data)) }
    end
  end
end
namespace :db do
  namespace :rm6232 do
    desc 'Generate the suppliers and converts to JSON'
    task generate_suppliers: :environment do
      DistributedLocks.distributed_lock(192) do
        ActiveRecord::Base.transaction do
          FM::RM6232::GenerateSuppliers.truncate_tables
          FM::RM6232::GenerateSuppliers.generate_suppliers
          FM::RM6232::GenerateSuppliers.convert_to_json
        rescue ActiveRecord::Rollback => e
          logger.error e.message
        end
      end
    end
  end
end
