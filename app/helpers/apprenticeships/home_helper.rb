module Apprenticeships::HomeHelper
  # TODO: TBD where this will sit
  def levels
    ['Level 2 (15)', 'Level 3 (24)', 'Level 4 (10)', 'Level 5 (2)', 'Level 6 (3)', 'Level 7 (1)']
  end

  # TODO: TBD where this will sit
  def routes
    ['Agriculture, environmental and animal care', 'Business administration', 'Catering and hospitality', 'Construction',
     'Creative and design', 'Digital', 'Engineering and manufacturing', 'Hair and beauty', 'Health and science',
     'Legal, finance and accounting', 'Protective services', 'Sales, marketing and procurement', 'Transport']
  end

  # TODO: TBD what options we have and where these will sit
  def sort_option
    ['Best match', 'Level', 'Provider(s)']
  end

  # TODO: TBD where this will sit
  def results
    [
      { name: 'Building Services Design Technician', level: 3, providers: 12 },
      { name: 'Building Services Design Engineer', level: 6, providers: 8 },
      { name: 'Vehicle Body and Paint: Body Building', level: 3, providers: 16 },
      { name: 'Construction Building: Trowel Occupations', level: 2, providers: 3 },
      { name: 'Construction Building: Trowel Occupations', level: 3, providers: 22 },
      { name: 'Building Services Engineering Technology and Project Management Technician', level: 3, providers: 2 },
      { name: 'Construction Building: Maintenance Operations', level: 2, providers: 18 },
      { name: 'Construction Building: Woodmachining', level: 2, providers: 44 },
      { name: 'Construction Site Engineering Technician', level: 4, providers: 12 },
      { name: 'Marine Engineer', level: 3, providers: 1 }
    ]
  end

  def ofsted_rating
    ['1 - Outstanding (0)', '2 - Good (3)', '3 - Requires improvements (5)']
  end

  def course_rating
    ['1 - Outstanding (1)', '2 - Good (5)', '3 - Requires improvements (2)']
  end

  def provider_experience
    ['Experience in apprenticeships', 'Experience in delivering this apprenticeship course']
  end

  def delivery_method
    ['Day Release(2)', 'Online(3)', 'Workplace Based(2)', 'Evenings (0)', 'Flexible around working pattern(1)']
  end

  def time_demand
    ['Day release{2}', 'Block release(0)', 'Evenings(0)', 'Flexible around working pattern(1)']
  end

  def classroom_sharing
    ['Open(4)', 'Closed(4)', 'Public(2)']
  end

  def training_availability
    ['Scheduled(5)', 'On demand(2)', 'Roll-on/Roll-off(3)']
  end

  def supplier_results
    [
      { name: 'ABC Training LTD National', rating: 2, distance: 7 },
      { name: 'DWK Group', rating: 2, distance: 22 },
      { name: 'A1 Training Solutions', rating: 2, distance: 14 },
      { name: 'North West Education LTD', rating: 3, distance: 5 },
      { name: 'OADS Training Group', rating: 3, distance: 103 },
      { name: 'Pimilico College of Building', rating: 3, distance: 53 },
      { name: 'United Colleges Groupi National', rating: 0, distance: 76 },
      { name: 'University of Liverpool', rating: 0, distance: 76 },
    ]
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

  def option_availability(option)
    option ? '✓' : 'x'
  end

  def list_from_array(array)
    array.collect do |item|
      content_tag(:li, item)
    end
  end
end
