class Supplier < ApplicationRecord
  class Framework < ApplicationRecord
    class Lot < ApplicationRecord
      class Jurisdiction < ApplicationRecord
        belongs_to :supplier_framework_lot, inverse_of: :jurisdictions, class_name: 'Supplier::Framework::Lot'
        belongs_to :jurisdiction, inverse_of: :supplier_framework_lot_jurisdictions

        has_many :rates, inverse_of: :jurisdiction, class_name: 'Supplier::Framework::Lot::Rate', foreign_key: :supplier_framework_lot_jurisdiction_id, dependent: :destroy
      end
    end
  end
end
