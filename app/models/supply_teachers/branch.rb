module SupplyTeachers
  class Branch < ApplicationRecord
    extend FriendlyId
    friendly_id :supplier_name, use: :slugged

    belongs_to :supplier,
               foreign_key: :supply_teachers_supplier_id,
               inverse_of: :branches

    validates :postcode, presence: true, postcode: true
    validates :location, presence: true
    validates :telephone_number, presence: true
    validates :contact_name, presence: true
    validates :contact_email, presence: true

    def self.near(point, within_metres:)
      where(
        [
          'ST_DWithin(location, :point, :within_metres)',
          point: point, within_metres: within_metres
        ]
      )
    end

    def self.search(point, rates:, radius:)
      metres = DistanceConverter.miles_to_metres(radius)
      Branch.includes(:supplier)
            .near(point, within_metres: metres)
            .joins(supplier: [:rates])
            .merge(rates)
            .order(Rate.arel_table[:mark_up].asc)
            .order(Arel.sql("ST_Distance(location, '#{point}')"))
    end

    def supplier_name
      supplier.name
    end
  end
end
