module JourneyHelper
  def checked?(actual, expected)
    actual == expected
  end

  def browse_routes
    [
      'Agriculture, environmental and animal care',
      'Business and administration',
      'Catering and hospitality',
      'Construction',
      'Creative and design',
      'Digital',
      'Engineering and manufacturing',
      'Hair and beauty',
      'Health and science',
      'Legal, finance and accounting',
      'Protective services',
      'Sales, marketing and procurement',
      'Transport and logistics',
    ]
  end

  def framework_and_number(number)
    framework = number.split('.')[0].gsub('1', '')
    lot_number = number.split('.')[1]

    "#{framework} Lot #{lot_number}"
  end

  def production_env?
    Rails.env.production?
  end
end
