module FacilitiesManagement
  class SecurityTypes < ApplicationRecord
    self.table_name = 'fm_security_types'
    self.primary_key = 'id'
  end
end

