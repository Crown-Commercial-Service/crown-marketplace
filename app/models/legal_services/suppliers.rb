module LegalServices
  class Suppliers
    include StaticRecord

    attr_accessor :supplier, :contact_email, :telephone_number, :website, :address, :sme, :duns, :lot1, :lot2, :lot3, :lot4

    def self.all_names
      all.map(&:name).map(&:to_s)
    end
  end

  Suppliers = CSV.read('data/legal_services/suppliers.csv')
end
