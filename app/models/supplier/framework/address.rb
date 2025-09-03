class Supplier < ApplicationRecord
  class Framework < ApplicationRecord
    class Address < ApplicationRecord
      belongs_to :supplier_framework, inverse_of: :address, class_name: 'Supplier::Framework'
    end
  end
end
