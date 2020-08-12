class AddMigrationToEnterDataIntoNewColumns < ActiveRecord::Migration[5.2]
  def self.up
    FacilitiesManagement::ProcurementBuildingService.where(code: %w[H.4 H.5 I.1 I.2 I.3 I.4 J.1 J.2 J.3 J.4 J.5 J.6]).find_in_batches do |group|
      sleep(5)
      group.each do |procurement_building_service|
        next if procurement_building_service.service_hours.nil?

        procurement_building_service.total_service_hours = total_hours(procurement_building_service.service_hours)
        description = ''
        description << "#{procurement_building_service.service_hours['personnel']} x people\r\n"
        %w[monday tuesday wednesday thursday friday saturday sunday].each do |day|
          description << full_daily_summary(day, procurement_building_service.service_hours[day])
        end
        procurement_building_service.detail_of_requirement = description
        procurement_building_service.save
      end
    end
  end

  def total_hours(attributes)
    total = 0
    attributes.each do |attribute, value|
      total += value['uom'] unless %w[uom personnel].include? attribute
    end
    (total * attributes['personnel'].to_i * 52).ceil
  end

  def full_daily_summary(day, attributes)
    case attributes['service_choice']
    when 'not_required'
      "#{day.capitalize}, not required\r\n"
    when 'all_day'
      "#{day.capitalize}, all day\r\n"
    when 'hourly'
      full_hourly_summary(day, attributes)
    end
  end

  NEXT_DAY = { monday: :tuesday,
               tuesday: :wednesday,
               wednesday: :thursday,
               thursday: :friday,
               friday: :saturday,
               saturday: :sunday,
               sunday: :monday }.freeze

  def full_hourly_summary(day, attributes)
    "#{day.capitalize}, #{time_summary(attributes, 'start')} to #{(next_day?(attributes) ? NEXT_DAY[day.to_sym] : day).capitalize}, #{time_summary(attributes, 'end')}\r\n"
  end

  def time_summary(attributes, point_of_day)
    time = attributes["#{point_of_day}_hour"].to_s
    time += ":#{attributes["#{point_of_day}_minute"]}" unless attributes["#{point_of_day}_minute"]&.zero?

    time += attributes["#{point_of_day}_ampm"]&.downcase
    time
  end

  def next_day?(attributes)
    return true if time_summary(attributes, 'end') == '12am'

    attributes['next_day']
  end

  def self.down; end
end
