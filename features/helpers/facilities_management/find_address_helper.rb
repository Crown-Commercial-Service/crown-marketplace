def stub_address_region_finder
  allow(Postcode::PostcodeCheckerV2).to receive(:find_region)
  allow(Postcode::PostcodeCheckerV2).to receive(:find_region).with('ST161AA').and_return(
    [{ code: 'UKG2', region: 'Shropshire and Staffordshire' }]
  )
  allow(Postcode::PostcodeCheckerV2).to receive(:find_region).with('ST16 1AA').and_return(
    [{ code: 'UKG2', region: 'Shropshire and Staffordshire' }]
  )
end
