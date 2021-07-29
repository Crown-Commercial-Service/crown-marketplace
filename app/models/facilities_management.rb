module FacilitiesManagement
  def self.table_name_prefix
    'facilities_management_'
  end

  RECOGNISED_FRAMEWORKS = ['RM3830', 'RM6232'].freeze
  DEFAULT_FRAMEWORK = 'RM3830'.freeze
end
