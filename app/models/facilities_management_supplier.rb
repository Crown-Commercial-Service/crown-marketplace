class FacilitiesManagementSupplier < ApplicationRecord
  has_many :regional_availabilities,
           class_name: 'FacilitiesManagement::RegionalAvailability',
           inverse_of: :supplier,
           dependent: :destroy

  has_many :service_offerings,
           class_name: 'FacilitiesManagementServiceOffering',
           inverse_of: :supplier,
           dependent: :destroy

  validates :name, presence: true

  def self.available_in_lot(lot_number)
    joins(:regional_availabilities)
      .merge(FacilitiesManagement::RegionalAvailability.for_lot(lot_number))
      .includes(:service_offerings)
      .uniq
  end

  def self.delete_all_with_dependents
    FacilitiesManagement::RegionalAvailability.delete_all
    FacilitiesManagementServiceOffering.delete_all
    delete_all
  end

  def self.available_in_lot_and_regions(lot_number, region_codes)
    where(id: FacilitiesManagement::RegionalAvailability
                .supplier_ids_for_lot_and_regions(lot_number, region_codes))
      .joins(:regional_availabilities)
      .merge(FacilitiesManagement::RegionalAvailability
               .for_lot_and_regions(lot_number, region_codes))
      .includes(:service_offerings)
      .uniq
  end

  def services_by_work_package_in_lot(lot_number)
    service_offerings_in_lot(lot_number).map(&:service).group_by(&:work_package)
  end

  def service_offerings_in_lot(lot_number)
    service_offerings.select { |so| so.lot_number == lot_number }
  end
end
