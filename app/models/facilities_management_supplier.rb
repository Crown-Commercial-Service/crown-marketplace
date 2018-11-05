class FacilitiesManagementSupplier < ApplicationRecord
  has_many :regional_availabilities,
           class_name: 'FacilitiesManagementRegionalAvailability',
           inverse_of: :supplier,
           dependent: :destroy

  has_many :service_offerings,
           class_name: 'FacilitiesManagementServiceOffering',
           inverse_of: :supplier,
           dependent: :destroy

  validates :name, presence: true

  def self.available_in_lot(lot_number)
    joins(:regional_availabilities)
      .merge(FacilitiesManagementRegionalAvailability.for_lot(lot_number))
      .uniq
  end

  def self.delete_all_with_dependents
    FacilitiesManagementRegionalAvailability.delete_all
    FacilitiesManagementServiceOffering.delete_all
    delete_all
  end

  def self.available_in_lot_and_regions(lot_number, region_codes)
    query = <<~SQL
      SELECT facilities_management_supplier_id AS id
      FROM facilities_management_regional_availabilities
      WHERE lot_number = :lot_number
      AND region_code IN (:region_codes)
      GROUP BY facilities_management_supplier_id
      HAVING count(region_code) = :region_code_count
    SQL
    query_params = {
      lot_number: lot_number,
      region_codes: region_codes,
      region_code_count: region_codes.length
    }

    ids = find_by_sql([query, query_params]).map(&:id)

    where(id: ids)
      .joins(:regional_availabilities)
      .merge(FacilitiesManagementRegionalAvailability.for_lot_and_regions(lot_number, region_codes))
      .uniq
  end

  def services_by_work_package_in_lot(lot_number)
    service_offerings.for_lot(lot_number).map(&:service).group_by(&:work_package)
  end
end
