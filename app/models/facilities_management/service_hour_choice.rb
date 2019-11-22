module FacilitiesManagement
  class ServiceHourChoice
    include ActiveModel::Model
    include Virtus.model
    include ActiveModel::Serialization

    attribute :not_required, Boolean, default: nil
    attribute :all_day, Boolean, default: nil
    attribute :start, Time, default: nil
    attribute :end, Time, default: nil

    def self.dump(service_hour_choice)
      new_hash = {}
      new_hash.merge!(service_hour_choice.attributes.select { |_key, value| value.present? })
      new_hash
    end

    def self.load(service_hour_choice)
      new(service_hour_choice)
    end

    validate :validate_choice

    def all_present?
      validate_choice
    end

    private

    def validate_choice
      errors.add(:base, :invalid) if attributes.keys.any? { |k| attributes[k].blank? }
    end
  end
end
