class Supplier < ApplicationRecord
  class Framework < ApplicationRecord
    class ContactDetail < ApplicationRecord
      belongs_to :supplier_framework, inverse_of: :contact_detail, class_name: 'Supplier::Framework'
    end
  end
end
