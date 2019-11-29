module FacilitiesManagement
  class ServiceHours
    include ActiveModel::Model
    include Virtus.model
    include ActiveModel::Serialization
    include ActiveModel::Callbacks

    # these are used to test
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

    validate :all_present?

    def initialize(params = {})
      super(params)
      # valid?
    end

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
      return ServiceHours.new if service_hours.blank?

      new(service_hours)
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

    PARAMETERS = { monday: ServiceHourChoice::PARAMETERS,
                   tuesday: ServiceHourChoice::PARAMETERS,
                   wednesday: ServiceHourChoice::PARAMETERS,
                   thursday: ServiceHourChoice::PARAMETERS,
                   friday: ServiceHourChoice::PARAMETERS,
                   saturday: ServiceHourChoice::PARAMETERS,
                   sunday: ServiceHourChoice::PARAMETERS }.freeze

    private

    def all_present?
      attributes.each do |key, value|
        value.valid?
        errors.add(key, :invalid) if value.errors.include? :service_choice
        errors.add(key, :not_a_date) if value.errors.include?(:start_time) || value.errors.include?(:end_time)
      end
    end

    def any_values?
      attributes.any? { |_k, v| v.valid? }
    end
  end
end
