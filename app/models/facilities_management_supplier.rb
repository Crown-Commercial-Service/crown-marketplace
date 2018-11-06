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
    where(id: FacilitiesManagementRegionalAvailability
                .supplier_ids_for_lot_and_regions(lot_number, region_codes))
      .joins(:regional_availabilities)
      .merge(FacilitiesManagementRegionalAvailability
               .for_lot_and_regions(lot_number, region_codes))
      .uniq
  end

  def services_by_work_package_in_lot(lot_number)
    service_offerings.for_lot(lot_number).map(&:service).group_by(&:work_package)
  end
end
