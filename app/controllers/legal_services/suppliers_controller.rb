module LegalServices
  class SuppliersController < FrameworkController
    require_permission :none, only: :index

    def index
      @back_path = :back
      @suppliers = [
        OpenStruct.new(name: 'XYZ Legal LTD', sme: true),
        OpenStruct.new(name: 'Vehement Capital Partners', sme: true),
        OpenStruct.new(name: 'Soylent LTD', sme: false),
        OpenStruct.new(name: 'Honey Electronics', sme: true),
        OpenStruct.new(name: 'Acme partners LTD', sme: false)
      ]
    end
  end
end
