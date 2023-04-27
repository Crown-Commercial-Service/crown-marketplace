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
