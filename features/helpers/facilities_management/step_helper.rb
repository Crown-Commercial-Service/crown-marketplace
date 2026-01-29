DATE_OPTION_TO_DATE = {
  'today' => -> { Time.zone.today },
  'yesterday' => -> { Time.zone.yesterday },
  'tomorrow' => -> { Time.zone.tomorrow },
  '1 month from now' => -> { Time.zone.today + 1.month },
}.freeze

def date_options_to_date(date)
  DATE_OPTION_TO_DATE[date].call
end

def date_options(date)
  case date.downcase
  when 'today', 'yesterday', 'tomorrow', '1 month from now'
    date_options_to_date(date).strftime('%d/%m/%Y')
  else
    date
  end.split('/')
end
