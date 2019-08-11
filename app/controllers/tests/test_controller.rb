module Tests
  class TestController < ActionController::Base
    ## skip_before_action :authenticate_user!
    # skip_before_action :authorize_user
    skip_before_action :verify_authenticity_token, only: [:index]

    respond_to :html, :json

    def index
      # params.permit!

      calculate params

      render layout: false
    end

    private

    def set_back_path
      @back_path = :back
    end

    def calculate(vals)
      id = SecureRandom.uuid

      b =
        {
          'id' => id,
          'gia' => vals['gia'],
          'name' => 'ccs',
          'region' => 'London',
          'address' =>
            {
              'fm-address-town' => 'London',
              'fm-address-line-1' => '151 Buckingham Palace Road',
              'fm-address-postcode' => 'SW1W 9SZ'
            },
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
    end
  end
end
