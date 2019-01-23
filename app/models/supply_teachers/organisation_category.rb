module SupplyTeachers
  class OrganisationCategory
    include Virtus.model
    include StaticRecord

    attribute :id, String
    attribute :name, String
    attribute :non_profit, Axiom::Types::Boolean

    def non_profit?
      non_profit
    end
  end

  OrganisationCategory.load_csv('supply_teachers/organisation_categories.csv')
end
