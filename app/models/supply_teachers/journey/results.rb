module SupplyTeachers
  module Journey::Results
    extend ActiveSupport::Concern
    include BranchesHelper
    include Geolocatable

    def branches(daily_rates = {})
      point = location.point
      Branch.search(point, rates: rates, radius: radius).map do |branch|
        search_result_for(branch).tap do |result|
          result.rate = rate(branch)
          result.distance = point.distance(branch.location)
          result.daily_rate = daily_rates.fetch(branch.id, nil)
          result.worker_cost = calculate_worker_cost(result)
          result.supplier_fee = calculate_supplier_fee(result)
        end
      end
    end

    def search_result_for(branch)
      BranchSearchResult.new(
        id: branch.id,
        supplier_name: branch.supplier.name,
        name: display_name_for_branch(branch),
        contact_name: branch.contact_name,
        telephone_number: branch.telephone_number,
        contact_email: branch.contact_email
      )
    end

    private

    def calculate_worker_cost(result)
      return unless result.daily_rate
      return if result.daily_rate.empty?
      result.daily_rate.to_i / (1 + result.rate)
    end

    def calculate_supplier_fee(result)
      return unless result.daily_rate
      return if result.daily_rate.empty?
      result.daily_rate.to_i - result.worker_cost
    end
  end
end
