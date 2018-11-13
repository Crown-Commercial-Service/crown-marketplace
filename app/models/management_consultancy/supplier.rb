module ManagementConsultancy
  class Supplier < ApplicationRecord
    validates :name, presence: true
  end
end
