module FacilitiesManagement
  class ServiceHours
    include Virtus.model

    attribute :monday, String
    attribute :tuesday, String
    attribute :wednesday, String
    attribute :thursday, String
    attribute :friday, String
    attribute :saturday, String
    attribute :sunday, String

    def self.dump(service_hours)
      service_hours.to_h
    end

    def self.load(service_hours)
      new(service_hours)
    end
  end
end
