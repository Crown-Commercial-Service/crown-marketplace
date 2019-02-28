module Apprenticeships::HomeHelper

  # TODO: TBD where these will sit
  def levels
    ['Level 2 (15)', 'Level 3 (24)', 'Level 4 (10)', 'Level 5 (2)', 'Level 6 (3)', 'Level 7 (1)']
  end

  def routes
    ['Agriculture, environmental and animal care', 'Business administration', 'Catering and hospitality', 'Construction',
     'Creative and design', 'Digital', 'Engineering and manufacturing', 'Hair and beauty', 'Health and science',
     'Legal, finance and accounting', 'Protective services', 'Sales, marketing and procurement', 'Transport']
  end

  def sort_option
    ['Best match', 'Level', 'Provider(s)']
  end

  def supplier_sort_option
    ['Overall ofsted rating (high to low)', 'Distance (closest first)', 'Overall ofset rating(low to high)']
  end

  def results
    [
      { name: 'Building Services Design Technician', level: 3, length:36, max_funding: 12000, providers: 12 },
      { name: 'Building Services Design Engineer', level: 6, length:60, max_funding: 27000, providers: 8 },
      { name: 'Vehicle Body and Paint: Body Building', level: 2, length:36, max_funding: 9000, providers: 16 },
      { name: 'Construction Building: Trowel Occupations', level: 3, length: 36, max_funding: 11000, providers: 3 },
      { name: 'Construction Building: Trowel Occupations', level: 3, length: 48 , max_funding: 182000, providers: 22 },
      { name: 'Construction Building: Woodmachining', level: 3, length: 24, max_funding: 8000, providers: 44 },
      { name: 'Construction Building: Woodmachining', level: 3, length: 24, max_funding: 8000, providers: 44 },
      { name: 'Construction Site Engineering Technician', level: 3, length: 24, max_funding: 8000, providers: 12 },
      { name: 'Marine Engineer', level: 3, length: 24, max_funding: 8000, providers: 1 }
    ]
  end

  def ofsted_rating
    [ '1 - Outstanding (0)', '2 - Good (3)', '3 - Requires improvements (5)']
  end

  def course_rating
    [ '1 - Outstanding (1)', '2 - Good (5)', '3 - Requires improvements (2)']
  end

  def provider_experience
    [ 'Experience in apprenticeships','Experience in delivering this apprenticeship course']
  end 

  def delivery_method
    [ 'Day Release(2)','Online(3)','Workplace Based(2)','Evenings (0)', 'Flexible around working pattern(1)']
  end

  def time_demand
    ['Day release{2}','Block release(0)','Evenings(0)','Flexible around working pattern(1)']
  end

  def classroom_sharing
    [ 'Open(4)','Closed(4)','Public(2)' ]
  end

  def training_availability
    ['Scheduled(5)','On demand(2)','Roll-on/Roll-off(3)' ]
  end

  def supplier_results
    [
      { name: 'ABC Training LTD National', rating: 2, distance: 7 },
      { name: 'DWK Group', rating: 2, distance: 22 },
      { name: 'A1 Training Solutions', rating: 2, distance: 14 },
      { name: 'North West Education LTD', rating: 3, distance: 5 },
      { name: 'OADS Training Group',rating: 3, distance: 103 },
      { name: 'Pimilico College of Building', rating: 3, distance: 53 },
      { name: 'United Colleges Groupi National', rating: 0, distance:76 },
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
end 
