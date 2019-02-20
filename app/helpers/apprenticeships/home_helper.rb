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
end