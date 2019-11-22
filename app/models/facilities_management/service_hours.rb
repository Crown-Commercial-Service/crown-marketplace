module FacilitiesManagement
  class ServiceHours
    include ActiveModel::Model
    include Virtus.model
    include ActiveModel::Serialization
    include ActiveModel::Callbacks

    attribute :monday, ServiceHourChoice, default: ServiceHourChoice.new
    attribute :tuesday, ServiceHourChoice, default: ServiceHourChoice.new
    attribute :wednesday, ServiceHourChoice, default: ServiceHourChoice.new
    attribute :thursday, ServiceHourChoice, default: ServiceHourChoice.new
    attribute :friday, ServiceHourChoice, default: ServiceHourChoice.new
    attribute :saturday, ServiceHourChoice, default: ServiceHourChoice.new
    attribute :sunday, ServiceHourChoice, default: ServiceHourChoice.new

    define_model_callbacks :initialize, only: [:after]
    after_initialize :valid?

    def self.dump(service_hours)
      return {} if service_hours.blank?

      new_hash = {}
      new_hash[:monday] = ServiceHourChoice.dump(service_hours[:monday])
      new_hash[:tuesday] = ServiceHourChoice.dump(service_hours[:tuesday])
      new_hash[:wednesday] = ServiceHourChoice.dump(service_hours[:wednesday])
      new_hash[:thursday] = ServiceHourChoice.dump(service_hours[:thursday])
      new_hash[:friday] = ServiceHourChoice.dump(service_hours[:friday])
      new_hash[:saturday] = ServiceHourChoice.dump(service_hours[:saturday])
      new_hash[:sunday] = ServiceHourChoice.dump(service_hours[:sunday])
      # service_hours.to_h
      new_hash
    end

    def self.load(service_hours)
      return new if service_hours.blank?

      new_obj = ServiceHours.new
      new_obj[:monday] = ServiceHourChoice.load(service_hours[:monday])
      new_obj[:tuesday] = ServiceHourChoice.load(service_hours[:tuesday])
      new_obj[:wednesday] = ServiceHourChoice.load(service_hours[:wednesday])
      new_obj[:thursday] = ServiceHourChoice.load(service_hours[:thursday])
      new_obj[:friday] = ServiceHourChoice.load(service_hours[:friday])
      new_obj[:saturday] = ServiceHourChoice.load(service_hours[:saturday])
      new_obj[:sunday] = ServiceHourChoice.load(service_hours[:sunday])

      new_obj
    end

    validate :all_present?

    def all_present?
      attributes.each do |choice|
        errors.add choice[0], :invalid if choice[1].invalid?
      end
    end

    def any_values?
      attributes.any? { |_k, v| v.valid? }
    end
  end
end
