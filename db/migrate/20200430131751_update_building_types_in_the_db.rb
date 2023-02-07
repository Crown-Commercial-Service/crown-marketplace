class UpdateBuildingTypesInTheDb < ActiveRecord::Migration[5.2]
  def up
    FacilitiesManagement::Building.all.each do |building|
      updated_building_type = BUILDING_TYPE_KEY[building.building_type&.to_sym]
      building.building_type = updated_building_type unless updated_building_type.nil?
      building.building_json[:'building-type'] = updated_building_type unless updated_building_type.nil?
      building.save
    end
  end

  BUILDING_TYPE_KEY = { 'General office - Customer Facing': 'General office - Customer Facing',
                        'General office - Non Customer Facing': 'General office - Non Customer Facing',
                        'Call-Centre-Operations': 'Call Centre Operations',
                        Warehouses: 'Warehouses',
                        'Restaurant-and-Catering-Facilities': 'Restaurant and Catering Facilities',
                        'Pre-School': 'Pre-School',
                        'Primary-School': 'Primary School',
                        'Secondary-School': 'Secondary Schools',
                        'Special-Schools': 'Special Schools',
                        'Universities-and-Colleges': 'Universities and Colleges',
                        'Doctors,-Dentists-and-Health-Clinics': 'Community - Doctors, Dentist, Health Clinic',
                        'Nursery-and-Care-Homes': 'Nursing and Care Homes' }.freeze
end
