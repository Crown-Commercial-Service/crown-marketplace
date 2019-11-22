require 'rails_helper'

RSpec.describe FacilitiesManagement::ServiceHours, type: :model do
  describe '#validation' do
    let(:service_hours) { described_class.new }

    context 'when empty and uninitialised' do
      it 'will be invalid' do
        expect(service_hours.valid?).to eq false
      end

      it 'will contain an error message for each day' do
        sh = FacilitiesManagement::ServiceHours.new
        sh.valid?
        expect(sh.errors.messages.length).to eq 7
      end
    end
  end

  describe 'Serialization' do
    let(:service_hours) { described_class.new }

    after do
      # Do nothing
    end

    context 'when saving as Hashmap' do
      before do
        service_hours[:tuesday][:all_day] = true
        service_hours[:wednesday][:all_day] = service_hours[:wednesday][:not_required] = false
        service_hours[:wednesday][:start] = '22:00'
        service_hours[:wednesday][:end] = '00:00'
      end

      it 'succeeds when serializing to a hash' do
        target = FacilitiesManagement::ServiceHours.dump(service_hours)
        expect(target[:tuesday][:all_day]).to eq true
      end

      it 'succeeds when serializing from a hash' do
        source = { monday: { not_required: nil, all_day: nil, start: nil, end: nil }, tuesday: { not_required: nil, all_day: true, start: nil, end: nil }, wednesday: { not_required: false, all_day: false, start: '22:00', end: '00:00' }, thursday: { not_required: nil, all_day: nil, start: nil, end: nil }, friday: { not_required: nil, all_day: nil, start: nil, end: nil }, saturday: { not_required: nil, all_day: nil, start: nil, end: nil }, sunday: { not_required: nil, all_day: nil, start: nil, end: nil } }
        target = FacilitiesManagement::ServiceHours.load(source)
        expect(target[:tuesday][:all_day]).to eq true
      end
    end

    context 'when data is nil or unassigned' do
      it 'succeeds when serializing to a hash' do
        target = FacilitiesManagement::ServiceHours.dump(service_hours)
        expect(target[:tuesday][:all_day]).to eq nil
      end

      it 'succeeds when serializing from a hash' do
        source = nil
        target = FacilitiesManagement::ServiceHours.load(source)
        expect(target[:tuesday][:all_day]).to eq nil
      end
    end
  end
end
