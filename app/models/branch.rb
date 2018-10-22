class Branch < ApplicationRecord
  DEFAULT_SEARCH_RANGE_IN_MILES = 25

  belongs_to :supplier

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

  def self.search(point, fixed_term: false)
    metres = DistanceConvertor.miles_to_metres(Branch::DEFAULT_SEARCH_RANGE_IN_MILES)
    Branch.near(point, within_metres: metres)
          .joins(supplier: [:rates])
          .merge(rates_clause(fixed_term))
          .order('rates.mark_up')
          .order(Arel.sql("ST_Distance(location, '#{point}')"))
  end

  def self.rates_clause(fixed_term)
    fixed_term ? Rate.fixed_term : Rate.nominated_worker
  end
end
