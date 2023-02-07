require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6232::Admin::SupplierData::Snapshot do
  let(:snapshot) do
    described_class.new(
      snapshot_date_yyyy: snapshot_date_yyyy,
      snapshot_date_mm: snapshot_date_mm,
      snapshot_date_dd: snapshot_date_dd,
      snapshot_time_hh: snapshot_time_hh,
      snapshot_time_mm: snapshot_time_mm
    )
  end
  let(:snapshot_date) { 1.day.from_now }
  let(:snapshot_date_yyyy) { snapshot_date.year.to_s }
  let(:snapshot_date_mm) { snapshot_date.month.to_s }
  let(:snapshot_date_dd) { snapshot_date.day.to_s }
  let(:snapshot_time_hh) { snapshot_date.hour.to_s }
  let(:snapshot_time_mm) { snapshot_date.min.to_s }

  describe 'validating the snapshot date time' do
    context 'when considering snapshot_date_yyyy and it is nil' do
      let(:snapshot_date_yyyy) { nil }

      it 'is not valid and has the correct error message' do
        expect(snapshot.valid?).to be false
        expect(snapshot.errors[:snapshot_date].first).to eq 'Enter a valid \'snapshot\' date'
      end
    end

    context 'when considering snapshot_date_mm and it is blank' do
      let(:snapshot_date_mm) { '' }

      it 'is not valid and has the correct error message' do
        expect(snapshot.valid?).to be false
        expect(snapshot.errors[:snapshot_date].first).to eq 'Enter a valid \'snapshot\' date'
      end
    end

    context 'when considering snapshot_date_dd and it is empty' do
      let(:snapshot_date_dd) { '    ' }

      it 'is not valid and has the correct error message' do
        expect(snapshot.valid?).to be false
        expect(snapshot.errors[:snapshot_date].first).to eq 'Enter a valid \'snapshot\' date'
      end
    end

    context 'when considering the snapshot_date' do
      context 'and it is not a real date' do
        let(:snapshot_date_yyyy) { snapshot_date.year.to_s }
        let(:snapshot_date_mm) { '2' }
        let(:snapshot_date_dd) { '30' }

        it 'is not valid and has the correct error message' do
          expect(snapshot.valid?).to be false
          expect(snapshot.errors[:snapshot_date].first).to eq 'Enter a valid \'snapshot\' date'
        end
      end
    end

    context 'when considering snapshot_time_hh' do
      let(:snapshot_time_mm) { nil }

      context 'and it is nil' do
        let(:snapshot_time_hh) { nil }

        it 'is valid' do
          expect(snapshot.valid?).to be true
        end
      end

      context 'and it is blank' do
        let(:snapshot_time_hh) { '' }

        it 'is valid' do
          expect(snapshot.valid?).to be true
        end
      end

      context 'and it is empty' do
        let(:snapshot_time_hh) { '    ' }

        it 'is valid' do
          expect(snapshot.valid?).to be true
        end
      end

      context 'and it is not a number' do
        let(:snapshot_time_hh) { 'Go Beyond' }

        it 'is not valid and has the correct error message' do
          expect(snapshot.valid?).to be false
          expect(snapshot.errors[:snapshot_time].first).to eq "Enter a valid 'snapshot' time (23:59 or earlier)"
        end
      end

      context 'and it is less than 0' do
        let(:snapshot_time_hh) { '-6' }

        it 'is not valid and has the correct error message' do
          expect(snapshot.valid?).to be false
          expect(snapshot.errors[:snapshot_time].first).to eq "Enter a valid 'snapshot' time (23:59 or earlier)"
        end
      end

      context 'and it is greater than 23' do
        let(:snapshot_time_hh) { '24' }

        it 'is not valid and has the correct error message' do
          expect(snapshot.valid?).to be false
          expect(snapshot.errors[:snapshot_time].first).to eq "Enter a valid 'snapshot' time (23:59 or earlier)"
        end
      end

      context 'and it has a zero at the start' do
        let(:snapshot_time_hh) { '02' }
        let(:snapshot_time_mm) { '8' }

        it 'is valid' do
          expect(snapshot.valid?).to be true
        end
      end
    end

    context 'when considering snapshot_time_mm' do
      let(:snapshot_time_hh) { nil }

      context 'and it is nil' do
        let(:snapshot_time_mm) { nil }

        it 'is valid' do
          expect(snapshot.valid?).to be true
        end
      end

      context 'and it is blank' do
        let(:snapshot_time_mm) { '' }

        it 'is valid' do
          expect(snapshot.valid?).to be true
        end
      end

      context 'and it is empty' do
        let(:snapshot_time_mm) { '    ' }

        it 'is valid' do
          expect(snapshot.valid?).to be true
        end
      end

      context 'and it is not a number' do
        let(:snapshot_time_mm) { 'Plus Ultra!' }

        it 'is not valid and has the correct error message' do
          expect(snapshot.valid?).to be false
          expect(snapshot.errors[:snapshot_time].first).to eq "Enter a valid 'snapshot' time (23:59 or earlier)"
        end
      end

      context 'and it is less than 0' do
        let(:snapshot_time_mm) { '-1' }

        it 'is not valid and has the correct error message' do
          expect(snapshot.valid?).to be false
          expect(snapshot.errors[:snapshot_time].first).to eq "Enter a valid 'snapshot' time (23:59 or earlier)"
        end
      end

      context 'and it is greater than 59' do
        let(:snapshot_time_mm) { '60' }

        it 'is not valid and has the correct error message' do
          expect(snapshot.valid?).to be false
          expect(snapshot.errors[:snapshot_time].first).to eq "Enter a valid 'snapshot' time (23:59 or earlier)"
        end
      end

      context 'and it has a zero at the start' do
        let(:snapshot_time_hh) { '2' }
        let(:snapshot_time_mm) { '08' }

        it 'is valid' do
          expect(snapshot.valid?).to be true
        end
      end
    end

    context 'when considering the snapshot_date_time' do
      let(:created_at) { DateTime.new(2022, 7, 5, 12, 45, 30).in_time_zone('London') }
      let(:snapshot_date) { created_at }

      before { FacilitiesManagement::RM6232::Admin::SupplierData.latest_data.update(created_at: created_at) }

      context 'and the date and time entered is before the oldest supplier data' do
        let(:snapshot_time_mm) { '44' }

        it 'is not valid and has the correct error message' do
          expect(snapshot.valid?).to be false
          expect(snapshot.errors[:snapshot_date_time].first).to eq 'You must enter a data and time on or after  5 July 2022, 13:45 (when the supplier data was imported for the first time)'
        end
      end

      context 'and the date and time entered is on the oldest supplier data' do
        it 'is valid' do
          expect(snapshot.valid?).to be true
        end
      end

      context 'and the date and time entered is after the oldest supplier data' do
        let(:snapshot_time_mm) { '46' }

        it 'is valid' do
          expect(snapshot.valid?).to be true
        end
      end
    end
  end

  describe 'create_snapshot_date_time' do
    context 'when in BST' do
      let(:snapshot_date) { Time.find_zone('London').local(2022, 7, 7) }

      context 'when the minutes and hours are blank' do
        let(:snapshot_time_hh) { nil }
        let(:snapshot_time_mm) { nil }

        it 'sets the snapshot_date_time time as 23:59' do
          expect(snapshot.snapshot_date_time.hour).to eq 23
          expect(snapshot.snapshot_date_time.min).to eq 59
        end
      end

      context 'when the minutes and hours are present' do
        let(:snapshot_time_hh) { 7 }
        let(:snapshot_time_mm) { 11 }

        it 'sets the snapshot_date_time time as minutes and hours passed' do
          expect(snapshot.snapshot_date_time.hour).to eq 6
          expect(snapshot.snapshot_date_time.min).to eq 11
        end
      end
    end

    context 'when in GMT' do
      let(:snapshot_date) { Time.find_zone('London').local(2022, 11, 11) }

      context 'when the minutes and hours are blank' do
        let(:snapshot_time_hh) { nil }
        let(:snapshot_time_mm) { nil }

        it 'sets the snapshot_date_time time as 23:59' do
          expect(snapshot.snapshot_date_time.hour).to eq 23
          expect(snapshot.snapshot_date_time.min).to eq 59
        end
      end

      context 'when the minutes and hours are present' do
        let(:snapshot_time_hh) { 7 }
        let(:snapshot_time_mm) { 11 }

        it 'sets the snapshot_date_time time as minutes and hours passed' do
          expect(snapshot.snapshot_date_time.hour).to eq 7
          expect(snapshot.snapshot_date_time.min).to eq 11
        end
      end
    end
  end

  describe 'snapshot_filename' do
    let(:snapshot_date) { Time.zone.local(2022, 7, 5, 13, 45, 30) }

    context 'when there are hours and minutes' do
      it 'returns the file name with the date and time formatted' do
        expect(snapshot.snapshot_filename).to eq('Supplier data spreadsheets (05_07_2022 13_45).zip')
      end
    end

    context 'when there are no hours and minutes' do
      let(:snapshot_time_hh) { '' }
      let(:snapshot_time_mm) { '' }

      it 'returns the file name with the date formatted' do
        expect(snapshot.snapshot_filename).to eq('Supplier data spreadsheets (05_07_2022).zip')
      end
    end
  end

  describe 'generate_snapshot_zip' do
    let(:snapshot_generator) { instance_double(FacilitiesManagement::RM6232::Admin::SupplierDataSnapshotGenerator) }

    before do
      allow(FacilitiesManagement::RM6232::Admin::SupplierDataSnapshotGenerator).to receive(:new).and_return(snapshot_generator)
      allow(snapshot_generator).to receive(:build_zip_file)
      allow(snapshot_generator).to receive(:to_zip)
    end

    it 'calls the expected methods' do
      snapshot.generate_snapshot_zip

      expect(FacilitiesManagement::RM6232::Admin::SupplierDataSnapshotGenerator).to have_received(:new).with(snapshot.snapshot_date_time)
      expect(snapshot_generator).to have_received(:build_zip_file)
      expect(snapshot_generator).to have_received(:to_zip)
    end
  end
end
