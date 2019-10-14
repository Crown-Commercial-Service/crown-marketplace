module FacilitiesManagement
  class Procurement < ApplicationRecord
    include AASM
    include ProcurementValidator

    belongs_to :user,
               foreign_key: :user_id,
               inverse_of: :procurements

    has_many :procurement_buildings, foreign_key: :facilities_management_procurement_id, inverse_of: :procurement, dependent: :destroy
    accepts_nested_attributes_for :procurement_buildings, allow_destroy: true
    acts_as_gov_uk_date :initial_call_off_start_date, validate_if: :validate_contract_data?

    #############################################
    # Validation rules for contract-dates
    # these rules need to cover
    #   initial_call_off_period (int)
    #   initial_call_off_start_date (date)
    #   initial_call_off_end_date (date)
    #   mobilisation_period (int)
    #   extension_period (int)
    #   optional_call_off_extensions_1 (int)
    #   optional_call_off_extensions_2 (int)
    #   optional_call_off_extensions_3 (int)
    #   optional_call_off_extensions_4 (int)
    # they are prepared and layed-out in logical sequence
    # they are tested in the appropriate rspec
    validates :initial_call_off_period, numericality: { allow_nil: false, only_integer: true,
                                                        greater_than_or_equal_to: 0 },
                                        if: :validate_call_off?

    validates :mobilisation_period, numericality: { allow_nil: false, only_integer: true,
                                                    greater_than: -1 },
                                    if: :validate_contract_data?

    validates :mobilisation_period, numericality: { allow_nil: false, only_integer: true,
                                                    greater_than_or_equal_to: 4 },
                                    if: -> { tupe? && (initial_call_off_period.present? ? initial_call_off_period.positive? : false) }

    validates :initial_call_off_start_date, presence: true, if: :mobilisation_period_expects_a_date?
    validates :initial_call_off_start_date, date: { allow_nil: true, after: proc { Time.current } },
                                            if: :mobilisation_period_expects_a_date?
    validates :initial_call_off_end_date, date: { after_or_equal_to: :initial_call_off_start_date },
                                          if: -> { initial_call_off_start_date.present? }
    validates :optional_call_off_extensions_1, date: { allow_nil: true }
    validates :optional_call_off_extensions_2, date: { allow_nil: true }
    validates :optional_call_off_extensions_3, date: { allow_nil: true }
    validates :optional_call_off_extensions_4, date: { allow_nil: true }

    def mobilisation_period_expects_a_date?
      if mobilisation_period.present?
        return true if !tupe? && mobilisation_period >= 1
        return true if tupe? && mobilisation_period >= 4
      end
      return false
    end

    def validate_call_off?
      initial_call_off_period.present?
    end

    def validate_contract_data?
      initial_call_off_period.present? ? initial_call_off_period.positive? : false
    end
    #
    # End of validation rules for contract-dates
    #############################################

    def unanswered_contract_date_questions?
      initial_call_off_period.nil? || initial_call_off_start_date.nil? || mobilisation_period.nil?
    end

    aasm do
      state :quick_search, initial: true
      state :detailed_search

      event :start_detailed_search do
        transitions from: :quick_search, to: :detailed_search
      end
    end

    def find_or_build_procurement_building(building_data)
      procurement_building = procurement_buildings.find_by(name: building_data['name']) || procurement_buildings.build(name: building_data['name'])
      procurement_building.address_line_1 = building_data['address']['fm-address-line-1']
      procurement_building.address_line_2 = building_data['address']['fm-address-line-2']
      procurement_building.town = building_data['address']['town']
      procurement_building.county = building_data['address']['county']
      procurement_building.postcode = building_data['address']['postcode']
      procurement_building.save
    end
  end
end
