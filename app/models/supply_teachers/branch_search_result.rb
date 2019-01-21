module SupplyTeachers
  class BranchSearchResult
    attr_reader :id
    attr_reader :supplier_name
    attr_reader :name
    attr_reader :contact_name
    attr_reader :telephone_number
    attr_reader :contact_email
    attr_accessor :rate
    attr_accessor :distance

    def initialize(id:, supplier_name:, name:, contact_name:,
                   telephone_number:, contact_email:)
      @id = id
      @supplier_name = supplier_name
      @name = name
      @contact_name = contact_name
      @telephone_number = telephone_number
      @contact_email = contact_email
    end
  end
end
