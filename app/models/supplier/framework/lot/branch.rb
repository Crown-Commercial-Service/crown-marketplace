class Supplier < ApplicationRecord
  class Framework < ApplicationRecord
    class Lot < ApplicationRecord
      class Branch < ApplicationRecord
        extend FriendlyId

        friendly_id :supplier_name, use: :slugged

        belongs_to :supplier_framework_lot, inverse_of: :branches, class_name: 'Supplier::Framework::Lot'

        validates :postcode, presence: true, postcode: true
        validates :location, presence: true
        validates :telephone_number, presence: true
        validates :contact_name, presence: true
        validates :contact_email, presence: true

        delegate :supplier_name, to: :supplier_framework_lot

        def self.search(point, lot_id:, position_id:, radius:)
          includes(
            supplier_framework_lot: [:rates, { supplier_framework: :supplier }]
          ).joins(
            supplier_framework_lot: [:rates, { supplier_framework: :supplier }]
          ).where(
            'ST_DWithin(location, :point, :within_metres)',
            { point: point, within_metres: DistanceConverter.miles_to_metres(radius) }
          ).where(
            supplier_framework_lot: { lot_id: lot_id, enabled: true, supplier_frameworks: { enabled: true } }
          ).merge(
            Rate.where(position_id:)
          ).order(
            Rate.arel_table[:rate].asc
          ).order(
            Arel.sql("ST_Distance(location, '#{point}')")
          )
        end

        def address_elements
          [address_line_1, address_line_2, town, county, postcode].compact_blank
        end
      end
    end
  end
end
