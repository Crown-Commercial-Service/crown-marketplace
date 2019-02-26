module FacilitiesManagement
  class Region
    include StaticRecord

    attr_accessor :code, :name

    def nuts1_code
      code[0, 3]
    end

    def nuts1_region
      Nuts1Region.find_by(code: nuts1_code)
    end

    def nuts2_code
      code[0, 4]
    end

    def nuts2_region
      Nuts2Region.find_by(code: nuts2_code)
    end

    def nuts3_code
      nuts3? ? code : nil
    end

    def nuts3_region
      nuts3? ? Nuts3Region.find_by(code: nuts3_code) : nil
    end

    def nuts3?
      code.length > 4
    end

    def nuts2?
      !nuts3?
    end

    def self.all_codes
      all.map(&:code)
    end
  end

  # Region.load_csv('facilities_management/regions.csv')
  begin
    query = <<~SQL
      SELECT code, name FROM fm_regions
    SQL
    Region.load_db(query)
  rescue => detail
    print detail.backtrace.join("\n")
  end

end
