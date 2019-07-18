module LegalServices
  class Lot4
    include StaticRecord

    attr_accessor :suppliers, :s1, :s2, :s3, :s4, :s5, :s6, :s7, :s8

    def self.all_suppliers
      all.map(&:suppliers).map(&:to_s)
    end
  end
end
