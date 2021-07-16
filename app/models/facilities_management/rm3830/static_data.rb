module FacilitiesManagement
  module RM3830
    class StaticData < ApplicationRecord
      def self.work_packages
        find_by(key: 'work_packages').value
      end

      def self.services
        find_by(key: 'services').value
      end

      def self.bank_holidays
        find_by(key: 'bank_holidays').value
      end
    end
  end
end
