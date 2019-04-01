module ManagementConsultancy
  class RateCard < ApplicationRecord
    belongs_to :supplier,
               foreign_key: :management_consultancy_supplier_id,
               inverse_of: :rate_cards

    def average_daily_rate
      ((junior_rate_in_pence +
      standard_rate_in_pence +
      senior_rate_in_pence +
      principal_rate_in_pence +
      managing_rate_in_pence +
      director_rate_in_pence).to_f / 600).ceil
    end
  end
end
