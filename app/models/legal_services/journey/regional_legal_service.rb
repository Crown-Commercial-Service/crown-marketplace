module LegalServices
  class Journey::RegionalLegalService
    include Steppable
    attribute :region1, Array
    validates :region1, length: { minimum: 1 }
    
    @regions = [['North East','NE'], ['North West','NW'],['Yorkshire and the Humber','YH'],['East Midlands','EM'], ['West Midlands','WM'],['East of England','EE'], ['Greater London','GL'], ['South East','SE'],['South West','SW'],['Wales','WA'],['Scotland','SC'],['Northern Ireland','NI']]

    def next_step_class
      Journey::Suppliers
    end
  end
end
