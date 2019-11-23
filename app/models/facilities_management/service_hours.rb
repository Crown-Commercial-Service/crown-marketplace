module FacilitiesManagement
  class ServiceHours
    include ActiveModel::Model
    include Virtus.model
    include ActiveModel::Serialization
    include ActiveModel::Callbacks

    # attribute :monday, ServiceHourChoice, default: ServiceHourChoice.new(service_choice: :not_required)
    # attribute :tuesday, ServiceHourChoice, default: ServiceHourChoice.new(service_choice: :all_day)
    # attribute :wednesday, ServiceHourChoice, default: ServiceHourChoice.new(service_choice: :hourly, start_hour: '10', start_minute: '00', start_ampm: 'pm', end_hour: 6, end_minute: 30, end_ampm: 'am')
    # attribute :thursday, ServiceHourChoice, default: ServiceHourChoice.new(service_choice: :all_day)
    # attribute :friday, ServiceHourChoice, default: ServiceHourChoice.new(service_choice: :not_required)
    # attribute :saturday, ServiceHourChoice, default: ServiceHourChoice.new(service_choice: :hourly, start_hour: '10', start_minute: '00', start_ampm: 'am', end_hour: 6, end_minute: 30, end_ampm: 'am')
    # attribute :sunday, ServiceHourChoice, default: ServiceHourChoice.new(service_choice: :hourly, start_hour: '10', start_minute: '00', start_ampm: 'am', end_hour: 6, end_minute: 30, end_ampm: 'pm')

    attribute :monday, ServiceHourChoice, default: ServiceHourChoice.new
    attribute :tuesday, ServiceHourChoice, default: ServiceHourChoice.new
    attribute :wednesday, ServiceHourChoice, default: ServiceHourChoice.new
    attribute :thursday, ServiceHourChoice, default: ServiceHourChoice.new
    attribute :friday, ServiceHourChoice, default: ServiceHourChoice.new
    attribute :saturday, ServiceHourChoice, default: ServiceHourChoice.new
    attribute :sunday, ServiceHourChoice, default: ServiceHourChoice.new

    define_model_callbacks :initialize, only: [:after]
    after_initialize :valid?

    validate :all_present?

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

    def total_hours_annually
      total_hours * 52
    end

    def total_hours
      total = 0
      attributes.each do |_k, v|
        total += v.total_hours
      end
      total
    end

    private

    def all_present?
      attributes.each do |key, value|
        errors.add key, :invalid unless value.valid?
      end
    end

    def any_values?
      attributes.any? { |_k, v| v.valid? }
    end
  end
end
