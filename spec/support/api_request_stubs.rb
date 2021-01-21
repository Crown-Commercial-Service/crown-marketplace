module APIRequestStubs
  def stub_bank_holiday_json
    before do
      stub_request(:get, 'https://www.gov.uk/bank-holidays.json')
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'Host' => 'www.gov.uk',
            'User-Agent' => 'Ruby'
          }
        )
        .to_return(status: 200, body: FacilitiesManagement::StaticData.bank_holidays.to_json, headers: {})
    end
  end
end
