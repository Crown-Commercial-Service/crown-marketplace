module LegalServices
  class Journey::ChooseRegions
    include Steppable

    attribute :region_codes, Array
    validates :region_codes, length: { minimum: 1 }
    validate :full_national_coverage_or_selected_regions

    def regions
      Nuts1Region.where(code: region_codes)
    end

    def lot(lot_number)
      LegalServices::Lot.find_by(number: lot_number)
    end

    def next_step_class
      Journey::Suppliers
    end

    def full_national_coverage_or_selected_regions
      return true unless region_codes.include?('UK')

      return true if region_codes.include?('UK') && region_codes.size == 1

      errors.add(:region_codes, :full_national_coverage)
    end
  end
end
