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
end
