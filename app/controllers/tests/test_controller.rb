module Tests
  class TestController < ActionController::Base
    ## skip_before_action :authenticate_user!
    # skip_before_action :authorize_user
    skip_before_action :verify_authenticity_token, only: [:index]

    respond_to :html, :json

    def index
      # params.permit!

      calculate params if params['gia']

      render layout: false
    end

    private

    def set_back_path
      @back_path = :back
    end

    def calculate(vals)
      id = SecureRandom.uuid

      rates = CCS::FM::Rate.read_benchmark_rates
      rate_card = CCS::FM::RateCard.latest

      start_date = Time.zone.today + 1

      data2 =
        {
          'posted_locations' => ['UKC1', 'UKC2'],
          'posted_services' => ['G.1', 'C.5', 'C.19', 'E.4', 'K.1', 'H.4', 'G.5', 'K.2', 'K.7'],
          'locations' => "('\"UKC1\"','\"UKC2\"')",
          'services' => "('\"G.1\"','\"C.5\"','\"C.19\"','\"E.4\"','\"K.1\"','\"H.4\"','\"G.5\"','\"K.2\"','\"K.7\"')",
          'start_date' => start_date,
          'contract-tupe-radio' => 'yes',
          'fm-contract-length' => 3
        }

      b =
        {
          'id' => id,
          'gia' => vals['gia'].to_f,
          # 'name' => 'ccs',
          # 'region' => 'London',
          # 'address' =>
          #   {
          #     'fm-address-town' => 'London',
          #     'fm-address-line-1' => '151 Buckingham Palace Road',
          #     'fm-address-postcode' => 'SW1W 9SZ'
          #   },
          'isLondon' => 'No',
          'services' =>
            [
              { 'code' => 'G-1', 'name' => 'Airport and aerodrome maintenance services' },
              { 'code' => 'M-1', 'name' => 'CAFM system' },
              # { 'code' => 'N-1', 'name' => 'Helpdesk services' },
              { 'code' => 'O-1', 'name' => 'Management of billable works' }
            ],
          'fm-building-type' => 'General office - Customer Facing'
        }

      all_buildings =
        [
          OpenStruct.new(building_json: b)
        ]
      uom_vals =
        [
          {
            'user_id' => 'dGVzdEBleGFtcGxlLmNvbQ==\n',
            'service_code' => 'G.1',
            'uom_value' => '125',
            'building_id' => id,
            'title_text' => "What's the number of building users (occupants) in this building?",
            'example_text' => "For example, 56. What's the maximum capacity of this building."
          }
        ]
      # data
      dummy_supplier_name = 'Hickle-Schinner'

      report = FacilitiesManagement::SummaryReport.new(start_date, 'test@example.com', data2)
      # prices = rate_card.data['Prices'].keys.map { |k| rate_card.data['Prices'][k]['C.1'] }
      report.calculate_services_for_buildings all_buildings, uom_vals, rates, rate_card, dummy_supplier_name

      # p report.assessed_value
      # expect(report.assessed_value.round(2)).to be 498881.62

      @assessed_value = report.assessed_value.round
    end
  end
end
