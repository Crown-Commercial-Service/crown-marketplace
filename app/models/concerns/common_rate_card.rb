module CommonRateCard
  extend ActiveSupport::Concern

  class_methods do
    def building_types
      [
        :'General office - Customer Facing',
        :'General office - Non Customer Facing',
        :'Call Centre Operations',
        :Warehouses,
        :'Restaurant and Catering Facilities',
        :'Pre-School',
        :'Primary School',
        :'Secondary Schools',
        :'Special Schools',
        :'Universities and Colleges',
        :'Community - Doctors, Dentist, Health Clinic',
        :'Nursing and Care Homes'
      ]
    end
  end
end
