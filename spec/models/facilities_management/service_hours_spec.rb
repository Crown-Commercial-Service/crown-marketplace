require 'rails_helper'

RSpec.describe FacilitiesManagement::ServiceHours, type: :model do
  let(:service_hours) { described_class.new }
  let(:source) do
    { 'monday': { service_choice: :not_required },
      'tuesday': { service_choice: :all_day },
      'wednesday': { service_choice: :hourly, start_hour: '10', start_minute: '00', start_ampm: 'pm', end_hour: 6, end_minute: 30, end_ampm: 'pm' },
      'thursday': { service_choice: :all_day }, friday: { service_choice: :not_required },
      'saturday': { service_choice: :hourly, start_hour: '10', start_minute: '00', start_ampm: 'am', end_hour: 6, end_minute: 30, end_ampm: 'pm' },
      'sunday': { service_choice: :hourly, start_hour: '10', start_minute: '00', start_ampm: 'am', end_hour: 6, end_minute: 30, end_ampm: 'pm' } }
  end

  before do
    service_hours[:monday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :not_required)
    service_hours[:tuesday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :all_day)
    service_hours[:wednesday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :hourly, start_hour: '08', start_minute: '00', start_ampm: 'am', end_hour: '05', end_minute: '30', end_ampm: 'pm')
    service_hours[:thursday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :not_required)
    service_hours[:friday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :all_day)
    service_hours[:saturday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :hourly, start_hour: '10', start_minute: '00', start_ampm: 'am', end_hour: '05', end_minute: '30', end_ampm: 'pm')
    service_hours[:sunday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :not_required)
  end

  describe '#validation' do
    context 'when empty and uninitialised' do
      let(:nil_sh) { described_class.new }

      it 'will be invalid' do
        described_class.new
        expect(nil_sh.valid?).to eq false
      end

      it 'will contain an error message for each day' do
        nil_sh.valid?
        expect(nil_sh.errors.messages.length).to eq 7
      end
    end

    describe '#service_choice' do
      let(:service_hours) { described_class.load(source) }

      it 'will be invalid when nil' do
        service_hours[:monday][:service_choice] = nil
        expect(service_hours.valid?).to eq false
        expect(service_hours[:monday].errors.keys.include?(:service_choice)).to eq true
      end

      it 'will be invalid when not in the list' do
        service_hours[:monday][:service_choice] = :all_hours
        expect(service_hours.valid?).to eq false
        expect(service_hours.errors.messages.length).to be == 1
      end

      it 'will be valid when in the list' do
        service_hours[:monday][:service_choice] = :not_required
        expect(service_hours.valid?).to eq true
      end
    end
  end

  describe '#serialization' do
    context 'when saving as hash' do
      it 'succeeds when serializing to a hash' do
        target = described_class.dump(service_hours)
        expect(target[:tuesday][:service_choice]).to eq 'all_day'
      end

      it 'validate uom when serializing to a hash' do
        target = described_class.dump(service_hours)
        expect(target[:saturday][:uom]).to eq 7.5
      end

      it 'succeeds when serializing from a json' do
        target = described_class.load(source)
        expect(target[:saturday][:service_choice]).to eq 'hourly'
      end
    end

    context 'when data is nil or unassigned' do
      it 'succeeds when serializing to a hash' do
        target = described_class.dump(service_hours)
        expect(target[:tuesday][:service_choice]).to eq 'all_day'
      end

      it 'succeeds when serializing from a nil hash' do
        source = nil
        target = described_class.load(source)
        expect(target[:tuesday][:service_choice]).to eq nil
      end
    end
  end
end
