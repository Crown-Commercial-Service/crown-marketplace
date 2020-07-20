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
    attribute :personnel, Integer
    attribute :uom, Integer, default: 0

    validates :personnel, presence: true, numericality: { only_integer: true, greater_than: 0, less_than: 1000 }
    validate :all_not_required?
    validate :all_present_and_valid?, unless: -> { all_days_not_required? }
    validate :no_days_overlap?, unless: -> { all_days_not_required? }

    def self.dump(service_hours)
      return {} if service_hours.blank?

      new_hash = {}
      %i[monday tuesday wednesday thursday friday saturday sunday].each do |day|
        new_hash[day] = ServiceHourChoice.dump(service_hours[day])
      end

      total_hours = new_hash.sum { |_key, shc| shc[:uom] }
      new_hash[:personnel] = service_hours[:personnel]
      new_hash[uom: total_hours * 52 * new_hash[:personnel].to_i]
      new_hash
    end

    def self.load(service_hours)
      return ServiceHours.new if service_hours.blank?

      new(service_hours)
    end

    def total_hours_annually
      (total_hours * 52)
    end

    def total_hours
      total = 0
      attributes.each do |k, v|
        total += v.total_hours unless %i[uom personnel].include? k
      end
      total * personnel.to_i
    end

    PARAMETERS = { monday: ServiceHourChoice::PARAMETERS,
                   tuesday: ServiceHourChoice::PARAMETERS,
                   wednesday: ServiceHourChoice::PARAMETERS,
                   thursday: ServiceHourChoice::PARAMETERS,
                   friday: ServiceHourChoice::PARAMETERS,
                   saturday: ServiceHourChoice::PARAMETERS,
                   sunday: ServiceHourChoice::PARAMETERS }.freeze

    NEXT_DAY = { monday: :tuesday,
                 tuesday: :wednesday,
                 wednesday: :thursday,
                 thursday: :friday,
                 friday: :saturday,
                 saturday: :sunday,
                 sunday: :monday }.freeze

    def to_summary(day)
      case attributes[day][:service_choice]
      when 'not_required'
        "#{shorten_day(day)}, #{I18n.t('facilities_management.procurement_buildings_services.day_section.not_required').downcase}"
      when 'all_day'
        "#{shorten_day(day)}, #{I18n.t('facilities_management.procurement_buildings_services.day_section.all_day').downcase}"
      else
        hourly_summary(day)
      end
    end

    private

    def validate_choice(key, value)
      value.validate_service_choice(key.to_s.capitalize)
      return if value.errors.any? || value.service_choice != 'hourly'

      value.validate_time_selection
      return if value.errors.any?

      value.validate_total_hours
      return if value.errors.any?

      value.validate_time_sequence(key.to_s.capitalize)
    end

    def all_present_and_valid?
      attributes.each do |key, value|
        next if %i[uom personnel].include? key

        validate_choice(key, value)
        errors.add(:base, :invalid) if value.errors.any?
      end
    end

    def all_not_required?
      errors.add(:base, :required) if all_days_not_required?
    end

    def all_days_not_required?
      count_of_not_required = 0
      attributes.each do |key, value|
        next if %i[uom personnel].include? key

        count_of_not_required += 1 if value.service_choice == 'not_required'
      end
      count_of_not_required == 7
    end

    def no_days_overlap?
      days = PARAMETERS.keys
      yesterdays = days.rotate(-1)
      days.each.with_index do |day, i|
        today = attributes[day]
        yesterday = attributes[yesterdays[i]]
        next unless valid_time_entries?(today, yesterday)

        case today[:service_choice]
        when 'all_day'
          add_overlap_errors(today, :all_day_overlap, day) if yesterday.end_time_integer > 2400
        else
          add_overlap_errors(today, :selection_overlap, day) if yesterday.end_time_integer > today.start_time_integer + 2400
        end
      end
    end

    def valid_time_entries?(today, yesterday)
      ['all_day', 'hourly'].include?(today[:service_choice]) && yesterday[:service_choice] == 'hourly' && today.errors.none? && yesterday.errors.none?
    end

    def hourly_summary(day)
      "#{shorten_day(day)}, #{attributes[day].start_time_summary} to #{shorten_day(next_day?(day) ? NEXT_DAY[day] : day)}, #{attributes[day].end_time_summary}"
    end

    def next_day?(day)
      return true if attributes[day].end_time_summary == '12am'

      attributes[day][:next_day]
    end

    def shorten_day(day)
      day.to_s.capitalize[0..2]
    end

    def add_overlap_errors(today, attribute, day)
      if attribute == :all_day_overlap
        today.errors.add(:service_choice, :all_day_overlap, day: day.to_s.capitalize)
      else
        today.errors.add(:start_time, :selection_overlap, day: day.to_s.capitalize)
      end
      errors.add(:base, :invalid)
    end
  end
end
