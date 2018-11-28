require 'csv'

module SupplyTeachers
  class DownloadsController < ApplicationController
    def index
      respond_to do |format|
        format.xlsx do
          spreadsheet = SupplyTeachers::AuditSpreadsheet.new
          render xlsx: spreadsheet.to_xlsx, filename: 'supply_teachers'
        end
      end
    end
  end
end
