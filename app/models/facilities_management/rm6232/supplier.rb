module FacilitiesManagement
  module RM6232
    class Supplier < ApplicationRecord
      has_many :lot_data, inverse_of: :supplier, class_name: 'FacilitiesManagement::RM6232::Supplier::LotData', dependent: :destroy, foreign_key: :facilities_management_rm6232_supplier_id
    end
  end
end
