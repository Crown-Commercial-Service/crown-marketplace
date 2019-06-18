module LegalServices
  class Details
    include StaticRecord

    header = {
      firm: 'firm',
      email_address: 'Generic_Contact_Email_address',
      phone_number: 'Generic_Contact_Phone_number',
      website: 'Generic_Contact_Website_URL',
      address: 'Generic_Contact_Postal_address',
      SME: 'Is_an_SME',
      DUNS_number: 'DUNS_Number',
      lot1_prospectus: 'Lot_1_Prospectus_Link',
      lot2_prospectus: 'Lot_2_Prospectus_Link',
      lot3_prospectus: 'Lot_3_Prospectus_Link',
      lot4_prospectus: 'Lot_4_Prospectus_Link',
      about: 'About_the_supplier'
    }

    attr_accessor header[:firm], header[:email_address], header[:phone_number], header[:website], header[:address], header[:SME], header[:DUNS_number], header[:lot1_prospectus], header[:lot2_prospectus], header[:lot3_prospectus], header[:lot4_prospectus], header[:about]

    def self.for_region(region, child_law, court_of_protection)
      where(region: region, child_law: child_law, court_of_protection: court_of_protection)
    end

    def self.for_sme(firm)
      where(firm: firm)
    end

    def full_description
      "Lot #{firm} - #{description}"
    end

    def self.all_firms
      all.map(&:firm)
    end

    def self.all_regions
      all.map(&:region)
    end
  end

  Details.load_csv('legal_service/supplierdetails.csv')
end
