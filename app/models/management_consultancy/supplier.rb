module ManagementConsultancy
  class Supplier < ApplicationRecord
    has_many :service_offerings,
             foreign_key: :management_consultancy_supplier_id,
             inverse_of: :supplier,
             dependent: :destroy

    validates :name, presence: true
  end
end
