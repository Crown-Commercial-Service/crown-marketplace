module FacilitiesManagement
  module Admin
    class ManagementReport
      include ActiveModel::Model
      include Virtus.model

      attr_accessor :start_date, :end_date

      validates :start_date, :end_date, presence: true

      def initialize(start_date, end_date)
        @start_date = start_date
        @end_date = end_date
      end
    end
  end
end
