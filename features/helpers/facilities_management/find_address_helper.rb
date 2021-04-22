def stub_address_region_finder
  allow(Postcode::PostcodeCheckerV2).to receive(:find_region).with('ST161AA').and_return(
    [{ code: 'UKG2', region: 'Shropshire and Staffordshire' }]
  )
end
