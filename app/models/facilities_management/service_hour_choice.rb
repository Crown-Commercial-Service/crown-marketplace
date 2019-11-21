module FacilitiesManagement
  class ServiceHourChoice
    include Virtus.model
    include ActiveModel::Model

    attribute :not_required, Boolean, default: nil
    attribute :all_day, Boolean, default: nil
    attribute :start, Time, default: nil
    attribute :end, Time, default: nil

    def self.dump(service_hour_choice)
      service_hour_choice.to_h
    end

    def self.load(service_hour_choice)
      new(service_hour_choice)
    end
  end
end
