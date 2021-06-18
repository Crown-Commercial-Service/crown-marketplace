def date_options(date)
  case date.downcase
  when 'today'
    Time.zone.today.strftime('%d/%m/%Y')
  when 'yesterday'
    Time.zone.yesterday.strftime('%d/%m/%Y')
  when 'tomorrow'
    Time.zone.tomorrow.strftime('%d/%m/%Y')
  else
    date
  end.split('/')
end

def format_date(date_object)
  date_object&.in_time_zone('London')&.strftime '%e %B %Y'
end

def format_date_period(start_date, end_date)
  "#{start_date.strftime('%e %B %Y')} to #{end_date.strftime('%e %B %Y')}".split(' ').join(' ')
end

def find_building(building_name)
  @user.buildings.find_by(building_name: building_name)
end

def find_supplier
  find_other_supplier('ca57bf4c-e8a5-468a-95f4-39fcf730c770')
end

def find_other_supplier(supplier_id)
  FacilitiesManagement::SupplierDetail.find(supplier_id)
end

PROCUREMENT_SUPPLIER_ATTRIBUTES = {
  sent: {},
  accepted: { supplier_response_date: Time.zone.today - 3.days },
  signed: { supplier_response_date: Time.zone.today - 3.days, contract_start_date: Time.zone.tomorrow, contract_end_date: Time.zone.tomorrow + 3.years, contract_signed_date: Time.zone.today },
  not_signed: { supplier_response_date: Time.zone.today - 3.days, contract_signed_date: Time.zone.today, reason_for_not_signing: 'The supplier would not respond to my emails' },
  declined: { supplier_response_date: Time.zone.today - 3.days, reason_for_declining: 'I cannot be bothered with it' },
  expired: { supplier_response_date: Time.zone.today - 3.days },
  withdrawn: { reason_for_closing: 'I got fed up of waiting', contract_closed_date: Time.zone.today }
}.freeze
