module FacilitiesManagement
  module Admin
    class Rates < ApplicationRecord
      self.table_name = 'fm_rates'

      validates_each :benchmark, :framework do |record, attr, _value|
        raw_value = record.read_attribute_before_type_cast(attr) # Because for e.g. 1 will get type cast to 1.0

        unless raw_value.blank? || raw_value.to_s.match(/(\A\d*\.\d+\z)|(\A\d+\z)/)
          record.errors.add(attr, :not_a_number,
                            message: I18n.t('facilities_management.admin.supplier_rates.supplier_framework_rates.not_a_number'))
        end
      end
    end
  end
end
