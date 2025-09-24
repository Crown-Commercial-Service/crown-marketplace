class Supplier < ApplicationRecord
  class Framework < ApplicationRecord
    class Lot < ApplicationRecord
      belongs_to :supplier_framework, inverse_of: :lots, class_name: 'Supplier::Framework'
      belongs_to :lot, inverse_of: :supplier_framework_lots

      has_many :services, inverse_of: :supplier_framework_lot, class_name: 'Supplier::Framework::Lot::Service', dependent: :destroy
      has_many :jurisdictions, inverse_of: :supplier_framework_lot, class_name: 'Supplier::Framework::Lot::Jurisdiction', dependent: :destroy
      has_many :rates, inverse_of: :supplier_framework_lot, class_name: 'Supplier::Framework::Lot::Rate', dependent: :destroy
      has_many :branches, inverse_of: :supplier_framework_lot, class_name: 'Supplier::Framework::Lot::Branch', dependent: :destroy

      delegate :supplier_name, to: :supplier_framework
    end
  end
end
