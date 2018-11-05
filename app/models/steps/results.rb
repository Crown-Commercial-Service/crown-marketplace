module Steps
  module Results
    extend ActiveSupport::Concern
    include BranchesHelper
    include Geolocatable

    included do
      attribute :postcode
      validates :location, location: true
    end

    def branches
      point = location.point
      Branch.search(point, rates: rates).map do |branch|
        search_result_for(branch).tap do |result|
          result.rate = rate(branch)
          result.distance = point.distance(branch.location)
        end
      end
    end

    def search_result_for(branch)
      BranchSearchResult.new(
        supplier_name: branch.supplier.name,
        name: display_name_for_branch(branch),
        contact_name: branch.contact_name,
        telephone_number: branch.telephone_number,
        contact_email: branch.contact_email
      )
    end
  end
end
