module LegalServices
  class SuppliersController < FrameworkController
    require_permission :none, only: :index

    def index
      @back_path = :back
      suppliers_array = mocked_suppliers
      @suppliers_count = suppliers_array.count
      @suppliers = Kaminari.paginate_array(suppliers_array).page(params[:page])
    end

    def show
      @back_path = :back
      @supplier = OpenStruct.new(name: params[:name], sme: params[:sme] == 'true')
    end

    def download_shortlist
      @back_path = :back
    end

    private

    def mocked_suppliers # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      [
        OpenStruct.new(name: 'XYZ Legal LTD', sme: true),
        OpenStruct.new(name: 'Vehement Capital Partners', sme: true),
        OpenStruct.new(name: 'Soylent LTD', sme: false),
        OpenStruct.new(name: 'Honey Electronics', sme: true),
        OpenStruct.new(name: 'Acme partners LTD', sme: false),
        OpenStruct.new(name: 'ABC LTD', sme: false),
        OpenStruct.new(name: 'Bahringer Inc', sme: false),
        OpenStruct.new(name: 'Kuhlman and Sons', sme: false),
        OpenStruct.new(name: 'Hayes-Stanton', sme: false),
        OpenStruct.new(name: 'Kemmer Group', sme: false),
        OpenStruct.new(name: 'Reinger, Bergstrom and Hammes', sme: false),
        OpenStruct.new(name: 'Gottlieb and Sons', sme: false),
        OpenStruct.new(name: 'Medhurst-Kemmer', sme: false),
        OpenStruct.new(name: 'Huels-Morissette', sme: false),
        OpenStruct.new(name: 'Romaguera, Pfannerstill and Cole', sme: false),
        OpenStruct.new(name: 'Kilback Group', sme: false),
        OpenStruct.new(name: 'Grant LLC', sme: true),
        OpenStruct.new(name: 'Wolff Group', sme: true),
        OpenStruct.new(name: 'Connelly Inc', sme: false),
        OpenStruct.new(name: 'Ankunding Inc', sme: false),
        OpenStruct.new(name: 'Goyette LLC', sme: true),
        OpenStruct.new(name: 'Nolan, Green and Schroeder', sme: false),
        OpenStruct.new(name: 'Emmerich, Greenfelder and Balistreri', sme: false),
        OpenStruct.new(name: 'Fahey, Deckow and Gulgowski', sme: false),
        OpenStruct.new(name: 'Cronin-Doyle', sme: false),
        OpenStruct.new(name: 'Kreiger-Rau', sme: false),
        OpenStruct.new(name: 'Anderson and Sons', sme: true),
        OpenStruct.new(name: 'Crooks-Hudson', sme: false),
        OpenStruct.new(name: 'Cruickshank, Schultz and Pfannerstill', sme: true),
        OpenStruct.new(name: 'Upton-Von', sme: true),
        OpenStruct.new(name: 'Hayes Inc', sme: false),
        OpenStruct.new(name: 'Schowalter Inc', sme: false),
        OpenStruct.new(name: 'Cronin LLC', sme: false),
        OpenStruct.new(name: 'Carroll-Smitham', sme: false),
        OpenStruct.new(name: 'Prohaska, Nitzsche and Schulist', sme: false),
        OpenStruct.new(name: 'Spencer-Schiller', sme: true),
        OpenStruct.new(name: 'Leffler Group', sme: false),
        OpenStruct.new(name: 'Klocko-Schmidt', sme: false),
        OpenStruct.new(name: 'Fisher-Yost', sme: true),
        OpenStruct.new(name: 'Schowalter, Cormier and Effertz', sme: false),
        OpenStruct.new(name: 'Roob and Sons', sme: false),
        OpenStruct.new(name: 'Rutherford and Sons', sme: true),
        OpenStruct.new(name: 'Walter, Witting and Von', sme: true),
        OpenStruct.new(name: 'Connelly-Funk', sme: false),
        OpenStruct.new(name: 'Casper Group', sme: false),
        OpenStruct.new(name: 'Fahey Inc', sme: false),
        OpenStruct.new(name: 'Terry-Hamill', sme: false),
        OpenStruct.new(name: 'Wilkinson-Moen', sme: true),
        OpenStruct.new(name: 'Rowe-Weissnat', sme: false),
        OpenStruct.new(name: 'Ankunding-Terry', sme: false),
        OpenStruct.new(name: 'Reinger, Bergstrom and Hammes', sme: false),
      ]
    end
  end
end
