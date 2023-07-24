require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::ManagementReportCsvGenerator do
  let(:management_report_csv_generator) { described_class.new(management_report.id) }
  let(:management_report) { create(:facilities_management_rm6232_admin_management_report, user: create(:user), start_date: start_date, end_date: end_date) }
  let(:start_date) { Time.zone.today - 1.year }
  let(:end_date) { Time.zone.today - 1.day }

  before { allow(FacilitiesManagement::RM6232::Admin::ManagementReportWorker).to receive(:perform_async).with(anything).and_return(true) }

  describe '.initialize' do
    it 'finds the management report' do
      expect(management_report_csv_generator.instance_variable_get(:@management_report)).to eq management_report
    end

    it 'sets the dates' do
      expect(management_report_csv_generator.instance_variable_get(:@start_date)).to eq start_date
      expect(management_report_csv_generator.instance_variable_get(:@end_date)).to eq end_date
    end
  end

  describe '.generate' do
    before do
      allow(management_report_csv_generator).to receive(:generate_csv).and_return('')
      management_report_csv_generator.generate
      management_report.reload
    end

    it 'attaches the file to the management report' do
      expect(management_report.management_report_csv).to be_attached
    end

    it 'attaches the file with the correct filename' do
      expect(management_report.management_report_csv.content_type).to eq 'text/csv'
    end

    it 'attaches the file with the correct content type' do
      created_at_string = management_report.created_at.in_time_zone('London').strftime '%Y%m%d-%H%M'
      start_date_string = start_date.strftime '%Y%m%d'
      end_date_string = end_date.strftime '%Y%m%d'

      expect(management_report.management_report_csv.filename.to_s).to eq "procurements_data_#{created_at_string}_#{start_date_string}-#{end_date_string}.csv"
    end

    it 'changes the management_report to completed' do
      expect(management_report.completed?).to be true
    end
  end

  describe 'generate_csv' do
    let(:test_users) { '' }
    let(:user_1) { create(:user, :with_detail) }
    let(:user_2) { create(:user) }

    let(:buyer_detail) { create(:buyer_detail, user: user_2, full_name: 'Obi-Wan Kenobi', job_title: 'Jedi', telephone_number: '0750050607', organisation_name: 'The Jedi Council', organisation_address_line_1: 'The Jedi Temple', organisation_address_line_2: nil, organisation_address_town: 'Coruscant', organisation_address_county: nil, organisation_address_postcode: 'SW1R 0TS', central_government: false, sector: nil, contact_opt_in: true) }

    let(:procurement_1) { create(:facilities_management_rm6232_procurement_what_happens_next, user: user_1, created_at: 3.days.ago, contract_name: 'Procurement 1') }
    let(:procurement_2) { create(:facilities_management_rm6232_procurement_what_happens_next, user: user_2, created_at: 2.days.ago, contract_name: 'Procurement 2', contract_number: 'RM6232-000002-2022') }
    let(:procurement_3) { create(:facilities_management_rm6232_procurement_what_happens_next, user: user_1, created_at: 1.day.ago, contract_name: 'Procurement 3', contract_number: 'RM6232-000003-2022', service_codes: %w[E.1 G.1 J.1], annual_contract_value: 50_000_000, lot_number: '1c') }
    let(:procurement_4) { create(:facilities_management_rm6232_procurement_what_happens_next, user: user_2, created_at: Time.zone.now, contract_name: 'Procurement 4', contract_number: 'RM6232-000004-2022', region_codes: %w[UKN01], annual_contract_value: 5_000_000) }

    let(:generated_csv) { CSV.parse(management_report.management_report_csv.download, headers: true) }

    before do
      ENV['TEST_USER_EMAILS'] = test_users
      buyer_detail
      procurement_1
      procurement_2
      procurement_3
      procurement_4
      management_report_csv_generator.generate
      management_report.reload
    end

    context 'when the dates are between 1 and 2 days ago' do
      let(:start_date) { 2.days.ago - 1.hour }
      let(:end_date) { 1.day.ago + 1.hour }

      it 'has 2 rows with 2nd and 3rd procurement' do
        expect(generated_csv.pluck(1)).to eq ['Procurement 3', 'Procurement 2']
      end
    end

    context 'when the dates are between 1 and 3 days ago' do
      let(:start_date) { 3.days.ago - 1.hour }
      let(:end_date) { 1.day.ago + 1.hour }

      it 'has 3 rows with 1st, 2nd and 3rd procurement' do
        expect(generated_csv.pluck(1)).to eq ['Procurement 3', 'Procurement 2', 'Procurement 1']
      end
    end

    context 'when the dates cover the range' do
      let(:start_date) { 5.days.ago }
      let(:end_date) { Time.zone.now }

      let(:generated_csv) { CSV.parse(management_report.management_report_csv.download) }

      it 'has the correct headers' do
        expect(generated_csv.first).to eq ['Reference number', 'Contract name', 'Date created', 'Buyer organisation', 'Buyer organisation address', 'Buyer sector', 'Buyer contact name', 'Buyer contact job title', 'Buyer contact email address', 'Buyer contact telephone number', 'Buyer opted in to be contacted', 'Services', 'Regions', 'Annual contract cost', 'Lot', 'Shortlisted Suppliers']
      end

      # rubocop:disable RSpec/MultipleExpectations
      it 'has the correct data' do
        expect(generated_csv[1][0..1] + generated_csv[1][3..]).to eq ['RM6232-000004-2022', 'Procurement 4', 'The Jedi Council', 'The Jedi Temple, Coruscant SW1R 0TS', 'Wider public sector', 'Obi-Wan Kenobi', 'Jedi', user_2.email, '="0750050607"', 'Yes', "E.1 Mechanical and Electrical Engineering Maintenance;\nE.2 Ventilation and air conditioning systems maintenance;\n", "UKN01 Belfast;\n", '5,000,000.00', '2a', "Conn, Hayes and Lakin;\nDach Inc;\nDonnelly, Wiegand and Krajcik;\nEmard, Green and Zboncak;\nFeest Group;\nHowell, Sanford and Shanahan;\nJenkins, Price and White;\nKirlin-Glover;\nMetz Inc;\nMoore Inc;\nSchulist-Wuckert;\nTorphy Inc;\nTremblay, Jacobi and Kozey;\nTurcotte and Sons;\nTurner-Pouros"]
        expect(generated_csv[2][0..1] + generated_csv[2][3..]).to eq ['RM6232-000003-2022',  'Procurement 3',  'MyString', 'MyString, MyString, MyString, MyString SW1W 9SZ', 'Defence and Security', 'MyString', 'MyString', user_1.email, '="07500404040"', 'Yes', "E.1 Mechanical and Electrical Engineering Maintenance;\nG.1 Hard Landscaping Services;\nJ.1 Mail Services;\n", "UKI4 Inner London - East;\nUKI5 Outer London - East and North East;\n", '50,000,000.00', '1c', "Berge-Koepp;\nBernier, Luettgen and Bednar;\nBins, Yost and Donnelly;\nBlick, O'Kon and Larkin;\nBreitenberg-Mante;\nCummerata, Lubowitz and Ebert;\nGoyette Group;\nHarris LLC;\nHeidenreich Inc;\nLind, Stehr and Dickinson;\nLowe, Abernathy and Toy;\nMiller, Walker and Leffler;\nMuller Inc;\nRohan-Windler;\nSatterfield LLC;\nSchmeler Inc;\nSchmeler-Leffler;\nSchultz-Wilkinson;\nTerry-Greenholt;\nYost LLC;\nZboncak and Sons"]
        expect(generated_csv[3][0..1] + generated_csv[3][3..]).to eq ['RM6232-000002-2022',  'Procurement 2',  'The Jedi Council', 'The Jedi Temple, Coruscant SW1R 0TS', 'Wider public sector', 'Obi-Wan Kenobi', 'Jedi', user_2.email, '="0750050607"', 'Yes', "E.1 Mechanical and Electrical Engineering Maintenance;\nE.2 Ventilation and air conditioning systems maintenance;\n", "UKI4 Inner London - East;\nUKI5 Outer London - East and North East;\n", '12,345.00', '2a', "Abshire, Schumm and Farrell;\nBrakus, Lueilwitz and Blanda;\nConn, Hayes and Lakin;\nDach Inc;\nFeest Group;\nHarber LLC;\nHudson, Spinka and Schuppe;\nJenkins, Price and White;\nKirlin-Glover;\nMetz Inc;\nMoore Inc;\nO'Reilly, Emmerich and Reichert;\nRoob-Kessler;\nSchulist-Wuckert;\nSkiles LLC;\nTorphy Inc;\nTremblay, Jacobi and Kozey;\nTurner-Pouros"]
        expect(generated_csv[4][0..1] + generated_csv[4][3..]).to eq ['RM6232-000001-2022',  'Procurement 1',  'MyString', 'MyString, MyString, MyString, MyString SW1W 9SZ', 'Defence and Security', 'MyString', 'MyString', user_1.email, '="07500404040"', 'Yes', "E.1 Mechanical and Electrical Engineering Maintenance;\nE.2 Ventilation and air conditioning systems maintenance;\n", "UKI4 Inner London - East;\nUKI5 Outer London - East and North East;\n", '12,345.00', '2a', "Abshire, Schumm and Farrell;\nBrakus, Lueilwitz and Blanda;\nConn, Hayes and Lakin;\nDach Inc;\nFeest Group;\nHarber LLC;\nHudson, Spinka and Schuppe;\nJenkins, Price and White;\nKirlin-Glover;\nMetz Inc;\nMoore Inc;\nO'Reilly, Emmerich and Reichert;\nRoob-Kessler;\nSchulist-Wuckert;\nSkiles LLC;\nTorphy Inc;\nTremblay, Jacobi and Kozey;\nTurner-Pouros"]
      end
      # rubocop:enable RSpec/MultipleExpectations
    end

    context 'when the buyer has not opted into being contacted' do
      let(:start_date) { 5.days.ago }
      let(:end_date) { Time.zone.now }
      let(:buyer_detail) { create(:buyer_detail, user: user_2, full_name: 'Obi-Wan Kenobi', job_title: 'Jedi', telephone_number: '0750050607', organisation_name: 'The Jedi Council', organisation_address_line_1: 'The Jedi Temple', organisation_address_line_2: nil, organisation_address_town: 'Coruscant', organisation_address_county: nil, organisation_address_postcode: 'SW1R 0TS', central_government: false, sector: nil, contact_opt_in: false) }

      let(:generated_csv) { CSV.parse(management_report.management_report_csv.download) }

      it 'has the correct headers' do
        expect(generated_csv.first).to eq ['Reference number', 'Contract name', 'Date created', 'Buyer organisation', 'Buyer organisation address', 'Buyer sector', 'Buyer contact name', 'Buyer contact job title', 'Buyer contact email address', 'Buyer contact telephone number', 'Buyer opted in to be contacted', 'Services', 'Regions', 'Annual contract cost', 'Lot', 'Shortlisted Suppliers']
      end

      # rubocop:disable RSpec/MultipleExpectations
      it 'has blank contact data for user 2' do
        expect(generated_csv[1][0..1] + generated_csv[1][3..]).to eq ['RM6232-000004-2022', 'Procurement 4', 'The Jedi Council', 'The Jedi Temple, Coruscant SW1R 0TS', 'Wider public sector', '', 'Jedi', '', '', 'No', "E.1 Mechanical and Electrical Engineering Maintenance;\nE.2 Ventilation and air conditioning systems maintenance;\n", "UKN01 Belfast;\n", '5,000,000.00', '2a', "Conn, Hayes and Lakin;\nDach Inc;\nDonnelly, Wiegand and Krajcik;\nEmard, Green and Zboncak;\nFeest Group;\nHowell, Sanford and Shanahan;\nJenkins, Price and White;\nKirlin-Glover;\nMetz Inc;\nMoore Inc;\nSchulist-Wuckert;\nTorphy Inc;\nTremblay, Jacobi and Kozey;\nTurcotte and Sons;\nTurner-Pouros"]
        expect(generated_csv[2][0..1] + generated_csv[2][3..]).to eq ['RM6232-000003-2022',  'Procurement 3',  'MyString', 'MyString, MyString, MyString, MyString SW1W 9SZ', 'Defence and Security', 'MyString', 'MyString', user_1.email, '="07500404040"', 'Yes', "E.1 Mechanical and Electrical Engineering Maintenance;\nG.1 Hard Landscaping Services;\nJ.1 Mail Services;\n", "UKI4 Inner London - East;\nUKI5 Outer London - East and North East;\n", '50,000,000.00', '1c', "Berge-Koepp;\nBernier, Luettgen and Bednar;\nBins, Yost and Donnelly;\nBlick, O'Kon and Larkin;\nBreitenberg-Mante;\nCummerata, Lubowitz and Ebert;\nGoyette Group;\nHarris LLC;\nHeidenreich Inc;\nLind, Stehr and Dickinson;\nLowe, Abernathy and Toy;\nMiller, Walker and Leffler;\nMuller Inc;\nRohan-Windler;\nSatterfield LLC;\nSchmeler Inc;\nSchmeler-Leffler;\nSchultz-Wilkinson;\nTerry-Greenholt;\nYost LLC;\nZboncak and Sons"]
        expect(generated_csv[3][0..1] + generated_csv[3][3..]).to eq ['RM6232-000002-2022',  'Procurement 2',  'The Jedi Council', 'The Jedi Temple, Coruscant SW1R 0TS', 'Wider public sector', '', 'Jedi', '', '', 'No', "E.1 Mechanical and Electrical Engineering Maintenance;\nE.2 Ventilation and air conditioning systems maintenance;\n", "UKI4 Inner London - East;\nUKI5 Outer London - East and North East;\n", '12,345.00', '2a', "Abshire, Schumm and Farrell;\nBrakus, Lueilwitz and Blanda;\nConn, Hayes and Lakin;\nDach Inc;\nFeest Group;\nHarber LLC;\nHudson, Spinka and Schuppe;\nJenkins, Price and White;\nKirlin-Glover;\nMetz Inc;\nMoore Inc;\nO'Reilly, Emmerich and Reichert;\nRoob-Kessler;\nSchulist-Wuckert;\nSkiles LLC;\nTorphy Inc;\nTremblay, Jacobi and Kozey;\nTurner-Pouros"]
        expect(generated_csv[4][0..1] + generated_csv[4][3..]).to eq ['RM6232-000001-2022',  'Procurement 1',  'MyString', 'MyString, MyString, MyString, MyString SW1W 9SZ', 'Defence and Security', 'MyString', 'MyString', user_1.email, '="07500404040"', 'Yes', "E.1 Mechanical and Electrical Engineering Maintenance;\nE.2 Ventilation and air conditioning systems maintenance;\n", "UKI4 Inner London - East;\nUKI5 Outer London - East and North East;\n", '12,345.00', '2a', "Abshire, Schumm and Farrell;\nBrakus, Lueilwitz and Blanda;\nConn, Hayes and Lakin;\nDach Inc;\nFeest Group;\nHarber LLC;\nHudson, Spinka and Schuppe;\nJenkins, Price and White;\nKirlin-Glover;\nMetz Inc;\nMoore Inc;\nO'Reilly, Emmerich and Reichert;\nRoob-Kessler;\nSchulist-Wuckert;\nSkiles LLC;\nTorphy Inc;\nTremblay, Jacobi and Kozey;\nTurner-Pouros"]
      end
      # rubocop:enable RSpec/MultipleExpectations
    end

    context 'when the buyer email is in the TEST_USER_EMAILS list' do
      let(:test_users) { user_2.email }
      let(:start_date) { 5.days.ago }
      let(:end_date) { Time.zone.now }

      let(:generated_csv) { CSV.parse(management_report.management_report_csv.download) }

      it 'has the correct headers' do
        expect(generated_csv.first).to eq ['Reference number', 'Contract name', 'Date created', 'Buyer organisation', 'Buyer organisation address', 'Buyer sector', 'Buyer contact name', 'Buyer contact job title', 'Buyer contact email address', 'Buyer contact telephone number', 'Buyer opted in to be contacted', 'Services', 'Regions', 'Annual contract cost', 'Lot', 'Shortlisted Suppliers']
      end

      it 'has the correct data' do
        expect(generated_csv.length).to eq 3
        expect(generated_csv[1][0..1] + generated_csv[1][3..]).to eq ['RM6232-000003-2022',  'Procurement 3',  'MyString', 'MyString, MyString, MyString, MyString SW1W 9SZ', 'Defence and Security', 'MyString', 'MyString', user_1.email, '="07500404040"', 'Yes', "E.1 Mechanical and Electrical Engineering Maintenance;\nG.1 Hard Landscaping Services;\nJ.1 Mail Services;\n", "UKI4 Inner London - East;\nUKI5 Outer London - East and North East;\n", '50,000,000.00', '1c', "Berge-Koepp;\nBernier, Luettgen and Bednar;\nBins, Yost and Donnelly;\nBlick, O'Kon and Larkin;\nBreitenberg-Mante;\nCummerata, Lubowitz and Ebert;\nGoyette Group;\nHarris LLC;\nHeidenreich Inc;\nLind, Stehr and Dickinson;\nLowe, Abernathy and Toy;\nMiller, Walker and Leffler;\nMuller Inc;\nRohan-Windler;\nSatterfield LLC;\nSchmeler Inc;\nSchmeler-Leffler;\nSchultz-Wilkinson;\nTerry-Greenholt;\nYost LLC;\nZboncak and Sons"]
        expect(generated_csv[2][0..1] + generated_csv[2][3..]).to eq ['RM6232-000001-2022',  'Procurement 1',  'MyString', 'MyString, MyString, MyString, MyString SW1W 9SZ', 'Defence and Security', 'MyString', 'MyString', user_1.email, '="07500404040"', 'Yes', "E.1 Mechanical and Electrical Engineering Maintenance;\nE.2 Ventilation and air conditioning systems maintenance;\n", "UKI4 Inner London - East;\nUKI5 Outer London - East and North East;\n", '12,345.00', '2a', "Abshire, Schumm and Farrell;\nBrakus, Lueilwitz and Blanda;\nConn, Hayes and Lakin;\nDach Inc;\nFeest Group;\nHarber LLC;\nHudson, Spinka and Schuppe;\nJenkins, Price and White;\nKirlin-Glover;\nMetz Inc;\nMoore Inc;\nO'Reilly, Emmerich and Reichert;\nRoob-Kessler;\nSchulist-Wuckert;\nSkiles LLC;\nTorphy Inc;\nTremblay, Jacobi and Kozey;\nTurner-Pouros"]
      end
    end
  end
end
