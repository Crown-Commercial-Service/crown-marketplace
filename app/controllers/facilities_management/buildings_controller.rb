require 'facilities_management/fm_buildings_data'
require 'json'
class FacilitiesManagement::BuildingsController < ApplicationController
  require_permission :facilities_management, only: %i[buildings new_building manual_address_entry_form save_building building_type update_building select_services_per_building units_of_measurement].freeze

  def select_services_per_building
    @inline_error_summary_title = 'Services are not selected'
    @inline_error_summary_body_href = '#fm-service-count'
    @inline_summary_error_text = 'You must select at least one service before continuing'
  end

  def buildings
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'Error'
    @fm_building_data = FMBuildingData.new
    @building_count = @fm_building_data.get_count_of_buildings(current_login.email.to_s)
    @building_data = @fm_building_data.get_building_data(current_login.email.to_s)
  end

  def new_building
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'error'
  end

  def manual_address_entry_form
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'error'
  end

  def save_building
    @new_building_json = request.raw_post
    @fm_building_data = FMBuildingData.new
    @fm_building_data.save_building(current_login.email.to_s, @new_building_json)
  end

  def update_building
    @new_building_json = request.raw_post
    obj = JSON.parse(@new_building_json)
    id = obj['id']
    @fm_building_data = FMBuildingData.new
    @fm_building_data.update_building(current_login.email.to_s, id, @new_building_json)
  end

  def units_of_measurement
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'error'
    @building_id = 'building_id'
    @building_name = 'Sandy airfield'
    @service_code = 'A-2'
    @service_title = 'Cleaning of external areas service'
    @uom_title = 'What is the number of building users (occupants) in this building?'
    @uom_example = 'For example, 56. When 56 people are based in this office'
    @unit_text = 'occupants (per year)'
    @is_lift = false
  end

  def building_type
    @inline_error_summary_title = 'There was a problem'
    @inline_error_summary_body_href = '#'
    @inline_summary_error_text = 'Please select an option before continuing'
    @type_list = ['General office - Customer Facing', 'General office - Non Customer Facing', 'Call Centre Operations',
                  'Warehouses', 'Restaurant and Catering Facilities', 'Pre-School', 'Primary School', 'Secondary School', 'Special Schools',
                  'Universities and Colleges', 'Doctors, Dentists and Health Clinics', 'Nursery and Care Homes', 'Data Centre Operations',
                  'External parks, grounds and car parks', 'Laboratory', 'Heritage Buildings', 'Nuclear Facilities', 'Animal Facilities',
                  'Custodial Facilities', 'Fire and Police Stations', 'Production Facilities', 'Workshops', 'Garages',
                  'Shopping Centres', 'Museums /Galleries', 'Fitness / Training Establishments', 'Residential Buildings',
                  'Port and Airport buildings', 'List X Property', 'Hospitals', 'Mothballed / Vacant / Disposal']
    @type_list_descriptions = { 'General office - Customer Facing' => 'General office areas and customer facing areas.',
                                'General office - Non Customer Facing' => 'General office areas and non-customer facing areas.',
                                'Call Centre Operations' => 'Call centre operations.',
                                'Warehouses' => 'Large storage facility with limited office space and low density occupation by Supplier Personnel.',
                                'Restaurant and Catering Facilities' => 'Areas including restaurants, deli-bars and coffee lounges areas used exclusively for consuming food and beverages.',
                                'Pre-School' => 'Pre-school, including crèche, nursery and after-school facilities.',
                                'Primary School' => 'Primary school facilities.',
                                'Secondary School' => 'Secondary school facilities.',
                                'Special Schools' => 'Special school facilities.',
                                'Universities and Colleges' => '	University and college, including on and off site campus facilities but excluding student residential accommodation facilities.',
                                'Doctors, Dentists and Health Clinics' => '	Community led facilities including doctors, dentists and health clinics.',
                                'Nursery and Care Homes' => '	Nursery and care home facilities.',
                                'Data Centre Operations' => 'Data centre operation.',
                                'External parks, grounds and car parks' => '	External car parks and grounds including externally fixed Assets - such as fences, gates, fountains etc.',
                                'Laboratory' => 'Includes all Government facilities where the standard of cleanliness is high, access is restricted and is not public facing.',
                                'Heritage Buildings' => 'Buildings of historical or cultural significance.',
                                'Nuclear Facilities' => 'Areas associated with Nuclear activities.',
                                'Animal Facilities' => 'Areas associated with the housing of animals such as dog kennels and stables.',
                                'Custodial Facilities' => 'Facilities relating to the detention of personnel such as prisons and detention centres.',
                                'Fire and Police Stations' => 'Areas associated with emergency services.',
                                'Production Facilities' => 'An environment centred around a fabrication or production facility, typically with restricted access.',
                                'Workshops' => 'Areas where works are undertaken such as joinery or metal working facilities',
                                'Garages' => 'Areas where motor vehicles are cleaned, serviced, repaired and maintained.',
                                'Shopping Centres' => 'Areas where retail services are delivered to the Public.',
                                'Museums /Galleries' => 'Areas are generally open to the public with some restrictions in place from time to time. Some facilities have no public access.',
                                'Fitness / Training Establishments' => 'Areas associated with fitness and leisure such as swimming pools, gymnasia, fitness centres and internal / external sports facilities.',
                                'Residential Buildings' => 'Residential accommodation / areas.',
                                'Port and Airport buildings' => 'Areas associated with air and sea transportation and supporting facilities, such as airports, aerodromes and dock areas.',
                                'List X Property' => 'A commercial site (i.e. non-Government) on UK soil that is approved to hold UK government protectively marked information marked as \'confidential\' and above. It is applied to a company\'s specific site and not a company as a whole.',
                                'Hospitals' => 'Areas including mainstream medical, healthcare facilities such as hospitals and medical centres.',
                                'Mothballed / Vacant / Disposal' => 'Areas which are vacant or awaiting disposal where no services are being undertaken.' }
  end
end
