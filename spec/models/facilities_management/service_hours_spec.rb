require 'rails_helper'

RSpec.describe FacilitiesManagement::ServiceHours, type: :model do
  let(:service_hours) { described_class.new }
  let(:source) do
    { 'monday': { service_choice: :not_required },
      'tuesday': { service_choice: :all_day },
      'wednesday': { service_choice: :hourly, start_hour: '10', start_minute: '00', start_ampm: 'PM', end_hour: 6, end_minute: 30, end_ampm: 'PM' },
      'thursday': { service_choice: :all_day }, friday: { service_choice: :not_required },
      'saturday': { service_choice: :hourly, start_hour: '10', start_minute: '00', start_ampm: 'AM', end_hour: 6, end_minute: 30, end_ampm: 'PM' },
      'sunday': { service_choice: :hourly, start_hour: '10', start_minute: '00', start_ampm: 'AM', end_hour: 6, end_minute: 30, end_ampm: 'PM' },
      'personnel': 1 }
  end

  def add_times_to_service_hours(start__time, end_time, day = :monday)
    service_hours[day][:service_choice] = :hourly
    service_hours[day][:start_hour] = start__time[0]
    service_hours[day][:start_minute] = start__time[1]
    service_hours[day][:start_ampm] = start__time[2]
    service_hours[day][:end_hour] = end_time[0]
    service_hours[day][:end_minute] = end_time[1]
    service_hours[day][:end_ampm] = end_time[2]
    service_hours[day][:next_day] = end_time[3]
  end

  before do
    service_hours[:monday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :not_required)
    service_hours[:tuesday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :all_day)
    service_hours[:wednesday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :hourly, start_hour: '08', start_minute: '00', start_ampm: 'AM', end_hour: '05', end_minute: '30', end_ampm: 'PM')
    service_hours[:thursday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :not_required)
    service_hours[:friday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :all_day)
    service_hours[:saturday] = FacilitiesManagement::ServiceHourChoice.new(service_choice: :hourly, start_hour: '10', start_minute: '00', start_ampm: 'AM', end_hour: '05', end_minute: '30', end_ampm: 'PM')
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
        day_errors = []
        nil_sh.attributes.reject { |k, _v| %i[uom personnel].include? k }.each do |_k, v|
          day_errors << v.errors.any?
        end
        expect(day_errors.length).to eq 7
      end
    end

    describe 'personnel' do
      let(:service_hours) { described_class.load(source) }

      context 'when the personnel is 0' do
        before { service_hours[:personnel] = 0 }

        it 'is not valid' do
          expect(service_hours.valid?).to eq false
        end

        it 'has the correct error' do
          service_hours.valid?
          expect(service_hours.errors.details[:personnel].first[:error]).to eq :greater_than
          expect(service_hours.errors[:personnel].first).to eq 'Enter a whole number between 1 and 999, like 300'
        end
      end

      context 'when the personnel is 1000' do
        before { service_hours[:personnel] = 1000 }

        it 'is not valid' do
          expect(service_hours.valid?).to eq false
        end

        it 'has the correct error' do
          service_hours.valid?
          expect(service_hours.errors.details[:personnel].first[:error]).to eq :less_than
          expect(service_hours.errors[:personnel].first).to eq 'Enter a whole number between 1 and 999, like 300'
        end
      end

      context 'when the personnel is blank' do
        before { service_hours[:personnel] = nil }

        it 'is not valid' do
          expect(service_hours.valid?).to eq false
        end

        it 'has the correct error' do
          service_hours.valid?
          expect(service_hours.errors.details[:personnel].first[:error]).to eq :blank
          expect(service_hours.errors[:personnel].first).to eq 'Enter a number of personnel'
        end
      end

      context 'when the personnel is not a number' do
        before { service_hours[:personnel] = 'Hello there' }

        it 'is not valid' do
          expect(service_hours.valid?).to eq false
        end

        it 'has the correct error' do
          service_hours.valid?
          expect(service_hours.errors.details[:personnel].first[:error]).to eq :not_a_number
          expect(service_hours.errors[:personnel].first).to eq 'Enter a whole number between 1 and 999, like 300'
        end
      end

      context 'when the personnel is an integer greater than 0' do
        it 'is valid' do
          service_hours[:personnel] = rand(1..10)

          expect(service_hours.valid?).to eq true
        end
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
      end

      it 'will be valid when in the list' do
        service_hours[:monday][:service_choice] = :not_required
        expect(service_hours.valid?).to eq true
      end

      context 'when not_required is selected for everyday' do
        before do
          service_hours[:monday][:service_choice] = :not_required
          service_hours[:tuesday][:service_choice] = :not_required
          service_hours[:wednesday][:service_choice] = :not_required
          service_hours[:thursday][:service_choice] = :not_required
          service_hours[:friday][:service_choice] = :not_required
          service_hours[:saturday][:service_choice] = :not_required
          service_hours[:sunday][:service_choice] = :not_required
        end

        it 'will be invalid' do
          expect(service_hours.valid?).to eq false
        end

        it 'will have the correct error message' do
          service_hours.valid?
          expect(service_hours.errors[:base].first).to eq 'You must provide hours required for at least one of the days'
        end
      end

      it 'will be valid if there are other option (all day)' do
        service_hours[:monday][:service_choice] = :all_day
        service_hours[:tuesday][:service_choice] = :not_required
        service_hours[:wednesday][:service_choice] = :not_required
        service_hours[:thursday][:service_choice] = :not_required
        service_hours[:friday][:service_choice] = :not_required
        service_hours[:saturday][:service_choice] = :not_required
        service_hours[:sunday][:service_choice] = :not_required
        expect(service_hours.valid?).to eq true
      end

      it 'will be valid if there are other options (hourly)' do
        add_times_to_service_hours(['10', '00', 'AM'], ['6', '30', 'PM', false], :monday)
        service_hours[:tuesday][:service_choice] = :not_required
        service_hours[:wednesday][:service_choice] = :not_required
        service_hours[:thursday][:service_choice] = :not_required
        service_hours[:friday][:service_choice] = :not_required
        service_hours[:saturday][:service_choice] = :not_required
        service_hours[:sunday][:service_choice] = :not_required
        expect(service_hours.valid?).to eq true
      end

      context 'when some values are missing' do
        before do
          add_times_to_service_hours(['10', nil, 'AM'], [nil, '30', 'PM'], :monday)
          service_hours[:tuesday][:service_choice] = :not_required
          service_hours[:wednesday][:service_choice] = :not_required
          service_hours[:thursday][:service_choice] = :not_required
          service_hours[:friday][:service_choice] = :not_required
          service_hours[:saturday][:service_choice] = :not_required
          service_hours[:sunday][:service_choice] = :not_required
        end

        it 'will not be valid' do
          expect(service_hours.valid?).to eq false
        end

        it 'will have the correct error messages' do
          service_hours.valid?
          expect(service_hours.attributes[:monday].errors[:end_time].first).to eq 'Select end time'
          expect(service_hours.attributes[:monday].errors[:start_time].first).to eq 'Select start time'
        end
      end

      context 'when all values are missing' do
        before do
          add_times_to_service_hours([nil, nil, nil], [nil, nil, nil], :monday)
          service_hours[:tuesday][:service_choice] = :not_required
          service_hours[:wednesday][:service_choice] = :not_required
          service_hours[:thursday][:service_choice] = :not_required
          service_hours[:friday][:service_choice] = :not_required
          service_hours[:saturday][:service_choice] = :not_required
          service_hours[:sunday][:service_choice] = :not_required
        end

        it 'will not be valid ' do
          expect(service_hours.valid?).to eq false
        end

        it 'will have the correct error message' do
          service_hours.valid?
          expect(service_hours.attributes[:monday].errors[:start_time].first).to eq 'Select start time'
          expect(service_hours.attributes[:monday].errors[:end_time].first).to eq 'Select end time'
        end
      end

      context 'when some values are missing at the weekend' do
        before do
          service_hours[:monday][:service_choice] = :not_required
          service_hours[:tuesday][:service_choice] = :not_required
          service_hours[:wednesday][:service_choice] = :not_required
          service_hours[:thursday][:service_choice] = :not_required
          service_hours[:friday][:service_choice] = :not_required
          add_times_to_service_hours(['08', '00', 'AM'], [nil, nil, nil], :saturday)
          add_times_to_service_hours([nil, nil, nil], [nil, nil, nil], :sunday)
        end

        it 'will not be valid' do
          expect(service_hours.valid?).to eq false
        end

        it 'will have the correct error messages' do
          service_hours.valid?
          expect(service_hours.attributes[:saturday].errors[:end_time].first).to eq 'Select end time'
          expect(service_hours.attributes[:sunday].errors[:start_time].first).to eq 'Select start time'
          expect(service_hours.attributes[:sunday].errors[:end_time].first).to eq 'Select end time'
        end
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

  describe '#midnight and other times' do
    let(:service_hours) { described_class.load(source) }

    before do
      service_hours[:tuesday][:service_choice] = :not_required
      service_hours[:wednesday][:service_choice] = :not_required
      service_hours[:thursday][:service_choice] = :not_required
      service_hours[:friday][:service_choice] = :not_required
      service_hours[:saturday][:service_choice] = :not_required
      service_hours[:sunday][:service_choice] = :not_required
      add_times_to_service_hours(['10', '00', 'PM'], ['11', '30', 'AM', true])
    end

    context 'when it is not midday or midnight' do
      it 'is valid when starting and ending in the morning' do
        add_times_to_service_hours(['10', '00', 'AM'], ['11', '30', 'AM'])

        expect(service_hours.valid?).to eq true
      end

      it 'returns 1.5 hours when starting and ending in the morning' do
        add_times_to_service_hours(['10', '00', 'AM'], ['11', '30', 'AM'])

        target = described_class.dump(service_hours)
        expect(target[:monday][:uom]).to eq 1.5
      end

      it 'is valid when starting and ending in the afternoon' do
        add_times_to_service_hours(['10', '00', 'PM'], ['11', '30', 'PM'])
        expect(service_hours.valid?).to eq true
      end

      it 'returns 1.5 hours when starting and ending in the afternoon' do
        add_times_to_service_hours(['10', '00', 'PM'], ['11', '30', 'PM'])

        target = described_class.dump(service_hours)
        expect(target[:monday][:uom]).to eq 1.5
      end

      it 'is valid when starting in the morning and ending in the afternoon' do
        add_times_to_service_hours(['10', '00', 'AM'], ['11', '30', 'PM'])
        expect(service_hours.valid?).to eq true
      end

      it 'returns 13.5 hours when starting in the morning and ending in the afternoon' do
        add_times_to_service_hours(['10', '00', 'AM'], ['11', '30', 'PM'])

        target = described_class.dump(service_hours)
        expect(target[:monday][:uom]).to eq 13.5
      end

      it 'is valid when starting in the afternoon and ending in the morning' do
        expect(service_hours.valid?).to eq true
      end

      it 'returns 13.5 hours when starting in the afternoon and ending in the morning' do
        target = described_class.dump(service_hours)
        expect(target[:monday][:uom]).to eq 13.5
      end

      it 'is invalid when the start time is after the end time with both times in the morning' do
        add_times_to_service_hours(['10', '00', 'AM'], ['09', '30', 'AM'])

        expect(service_hours.valid?).to eq false
        expect(service_hours.attributes[:monday].errors[:end_time].first).to eq 'The end time must be after the start time for Monday'
      end

      it 'is invalid when the start time is after the end time with both times in the afternoon' do
        add_times_to_service_hours(['10', '00', 'PM'], ['08', '30', 'PM'])

        expect(service_hours.valid?).to eq false
        expect(service_hours.attributes[:monday].errors[:end_time].first).to eq 'The end time must be after the start time for Monday'
      end
    end

    context 'when it is midday' do
      it 'is valid when starting in the morning and ending at midday' do
        add_times_to_service_hours(['10', '00', 'AM'], ['12', '00', 'PM'])

        expect(service_hours.valid?).to eq true
      end

      it 'returns 2 hours when starting in the morning and ending at midday' do
        add_times_to_service_hours(['10', '00', 'AM'], ['12', '00', 'PM'])

        target = described_class.dump(service_hours)
        expect(target[:monday][:uom]).to eq 2
      end

      it 'is valid when starting at midday and ending in the afternoon' do
        add_times_to_service_hours(['12', '00', 'PM'], ['06', '30', 'PM'])

        expect(service_hours.valid?).to eq true
      end

      it 'returns 6.5 hours when starting at midday and ending at 6.30pm' do
        add_times_to_service_hours(['12', '00', 'PM'], ['06', '30', 'PM'])

        target = described_class.dump(service_hours)
        expect(target[:monday][:uom]).to eq 6.5
      end

      it 'is valid when starting at midday and ending at midnight' do
        add_times_to_service_hours(['12', '00', 'PM'], ['12', '00', 'AM'])

        expect(service_hours.valid?).to eq true
      end

      it 'returns 12 hours when starting at midday and ending at midnight' do
        add_times_to_service_hours(['12', '00', 'PM'], ['12', '00', 'AM'])

        target = described_class.dump(service_hours)
        expect(target[:monday][:uom]).to eq 12
      end
    end

    context 'when it is midnight' do
      before do
        add_times_to_service_hours(['06', '00', 'AM'], ['12', '00', 'AM'])
      end

      it 'is valid when starting in the morning and ending at midnight' do
        expect(service_hours.valid?).to eq true
      end

      it 'returns 18 hours when starting in the morning and ending at midnight' do
        target = described_class.dump(service_hours)
        expect(target[:monday][:uom]).to eq 18
      end

      it 'is valid when starting in the afternoon and ending at midnight' do
        add_times_to_service_hours(['10', '00', 'PM'], ['12', '00', 'AM'])

        expect(service_hours.valid?).to eq true
      end

      it 'returns 2 hours when starting in the afternoon and ending at midnight' do
        add_times_to_service_hours(['10', '00', 'PM'], ['12', '00', 'AM'])

        target = described_class.dump(service_hours)
        expect(target[:monday][:uom]).to eq 2
      end

      it 'is valid when starting at midnight and ending in the afternoon' do
        add_times_to_service_hours(['12', '00', 'AM'], ['06', '30', 'PM'])

        expect(service_hours.valid?).to eq true
      end

      it 'returns 18.5 hours when starting at midnight and ending in the afternoon' do
        add_times_to_service_hours(['12', '00', 'AM'], ['06', '30', 'PM'])

        target = described_class.dump(service_hours)
        expect(target[:monday][:uom]).to eq 18.5
      end

      it 'is valid when starting at midnight and ending at midday' do
        add_times_to_service_hours(['12', '00', 'AM'], ['12', '00', 'PM'])

        expect(service_hours.valid?).to eq true
      end

      it 'returns 12 hours when starting at midnight and ending in the afternoon' do
        add_times_to_service_hours(['12', '00', 'AM'], ['12', '00', 'PM'])

        target = described_class.dump(service_hours)
        expect(target[:monday][:uom]).to eq 12
      end

      it 'is valid when starting at midday and ending at midnight' do
        add_times_to_service_hours(['12', '00', 'PM'], ['12', '00', 'AM', true])

        expect(service_hours.valid?).to eq true
      end

      it 'returns 12 hours when starting at midday and ending at midnight' do
        add_times_to_service_hours(['12', '00', 'PM'], ['12', '00', 'AM', true])

        target = described_class.dump(service_hours)
        expect(target[:monday][:uom]).to eq 12
      end

      it 'is valid when when starting at 1am and ending in at 12:45 next day' do
        add_times_to_service_hours(['01', '00', 'AM'], ['12', '45', 'AM', true])

        expect(service_hours.valid?).to eq true
      end

      it 'returns 23.75 hours when starting at 1am and ending in at 12:45 next day' do
        add_times_to_service_hours(['01', '00', 'AM'], ['12', '45', 'AM', true])

        target = described_class.dump(service_hours)
        expect(target[:monday][:uom]).to eq 23.75
      end

      it 'returns 0.75 hours when starting at 12am and ending in at 12:45 same day' do
        add_times_to_service_hours(['12', '00', 'AM'], ['12', '45', 'AM', false])

        target = described_class.dump(service_hours)
        expect(target[:monday][:uom]).to eq 0.75
      end
    end

    context 'when overlapping from sunday to monday' do
      it 'is not valid when the days overlap due to the selected hours' do
        add_times_to_service_hours(['01', '00', 'AM'], ['12', '45', 'AM', true])
        add_times_to_service_hours(['05', '00', 'PM'], ['07', '00', 'AM', true], :sunday)

        expect(service_hours.valid?).to eq false
        expect(service_hours.attributes[:monday].errors[:start_time].first).to eq 'The start time of Monday cannot be earlier than the end time of the previous day'
      end

      it 'is not valid when the days overlap due to 24 hours selected' do
        service_hours[:monday][:service_choice] = :all_day
        add_times_to_service_hours(['05', '00', 'PM'], ['07', '00', 'AM', true], :sunday)

        expect(service_hours.valid?).to eq false
        expect(service_hours.attributes[:monday].errors[:service_choice].first).to eq 'The start time of Monday cannot be earlier than the end time of the previous day'
      end

      it 'is valid when valid times are entered into sunday and not required on monday' do
        service_hours[:monday][:service_choice] = :not_required
        add_times_to_service_hours(['05', '00', 'PM'], ['07', '00', 'AM', true], :sunday)

        expect(service_hours.valid?).to eq true
      end

      it 'is valid when valid times are entered into sunday and selected times on monday' do
        add_times_to_service_hours(['08', '00', 'AM'], ['12', '45', 'AM', true])
        add_times_to_service_hours(['05', '00', 'PM'], ['07', '00', 'AM', true], :sunday)

        expect(service_hours.valid?).to eq true
      end
    end
  end

  describe '#total hour calculations' do
    let(:service_hours) { described_class.load(source) }

    before do
      service_hours[:monday][:service_choice] = :not_required
      service_hours[:tuesday][:service_choice] = :not_required
      service_hours[:wednesday][:service_choice] = :not_required
      service_hours[:thursday][:service_choice] = :not_required
      service_hours[:friday][:service_choice] = :not_required
      service_hours[:saturday][:service_choice] = :not_required
      service_hours[:sunday][:service_choice] = :not_required
    end

    context 'with small hours differences' do
      it 'will return 52 hours when one hour is chosen for a service in the morning' do
        add_times_to_service_hours(['10', '00', 'AM'], ['11', '00', 'AM'])

        expect(service_hours.total_hours_annually).to eq 52
      end

      it 'will return 104 hours when two hours are chosen for a service in the morning' do
        add_times_to_service_hours(['10', '00', 'AM'], ['12', '00', 'PM'])

        expect(service_hours.total_hours_annually).to eq 104
      end

      it 'will return 52 hours when one hour is chosen for a service in the afternoon' do
        add_times_to_service_hours(['10', '00', 'PM'], ['11', '00', 'PM'])

        expect(service_hours.total_hours_annually).to eq 52
      end

      it 'will return 104 hours when two hours are chosen for a service in the afternoon' do
        add_times_to_service_hours(['10', '00', 'PM'], ['12', '00', 'AM'])

        expect(service_hours.total_hours_annually).to eq 104
      end

      it 'will return 13 hours when two hours are early in the morning' do
        add_times_to_service_hours(['12', '00', 'AM'], ['12', '15', 'AM'])

        expect(service_hours.total_hours_annually).to eq 13
      end
    end

    context 'with intermediate hour differences' do
      it 'will return 65 hours when one and a quarter hours are chosen for a service' do
        add_times_to_service_hours(['09', '00', 'AM'], ['10', '15', 'AM'])

        expect(service_hours.total_hours_annually).to eq 65
      end

      it 'will return 78 hours when one and a half hours are chosen for a service' do
        add_times_to_service_hours(['09', '00', 'AM'], ['10', '30', 'AM'])

        expect(service_hours.total_hours_annually).to eq 78
      end

      it 'will return 91 hours when one and three quarter hours are chosen for a service' do
        add_times_to_service_hours(['09', '00', 'AM'], ['10', '45', 'AM'])

        expect(service_hours.total_hours_annually).to eq 91
      end

      it 'will return 117 hours when two and a quarter hours are chosen for a service' do
        add_times_to_service_hours(['09', '00', 'AM'], ['11', '15', 'AM'])

        expect(service_hours.total_hours_annually).to eq 117
      end
    end

    context 'with large hour differences' do
      it 'will return 260 hours when five hours are chosen for a service spanning the morning' do
        add_times_to_service_hours(['04', '00', 'AM'], ['09', '00', 'AM'])

        expect(service_hours.total_hours_annually).to eq 260
      end

      it 'will return 416 hours when eight hours are chosen for a service spanning the afternoon' do
        add_times_to_service_hours(['12', '00', 'PM'], ['08', '00', 'PM'])

        expect(service_hours.total_hours_annually).to eq 416
      end

      it 'will return 260 hours when five hours are chosen for a service from the morning to the afternoon' do
        add_times_to_service_hours(['09', '00', 'AM'], ['02', '00', 'PM'])

        expect(service_hours.total_hours_annually).to eq 260
      end

      it 'will return 416 hours when eight hours are chosen for a service from the night into the morning' do
        add_times_to_service_hours(['09', '00', 'PM'], ['05', '00', 'AM', true])

        expect(service_hours.total_hours_annually).to eq 416
      end
    end

    context 'with large hour differences with intermediate times' do
      it 'will return 273 hours when five and a quarter hours are chosen for a service spanning the morning' do
        add_times_to_service_hours(['04', '00', 'AM'], ['09', '15', 'AM'])

        expect(service_hours.total_hours_annually).to eq 273
      end

      it 'will return 442 hours when eight and a half hours are chosen for a service spanning the afternoon' do
        add_times_to_service_hours(['12', '00', 'PM'], ['08', '30', 'PM'])

        expect(service_hours.total_hours_annually).to eq 442
      end

      it 'will return 455 hours when eight and a three quarter hours are chosen for a service spanning the afternoon' do
        add_times_to_service_hours(['12', '00', 'PM'], ['08', '45', 'PM'])

        expect(service_hours.total_hours_annually).to eq 455
      end

      it 'will return 273 hours when five and a quarter hours are chosen for a service from the morning to the afternoon' do
        add_times_to_service_hours(['09', '00', 'AM'], ['02', '15', 'PM'])

        expect(service_hours.total_hours_annually).to eq 273
      end

      it 'will return 442 hours when eight and a half hours are chosen for a service from the night into the morning' do
        add_times_to_service_hours(['09', '00', 'PM'], ['05', '30', 'AM', true])

        expect(service_hours.total_hours_annually).to eq 442
      end

      it 'will return 455 hours when eight and three quarter hours are chosen for a service from the night into the morning' do
        add_times_to_service_hours(['09', '00', 'PM'], ['05', '45', 'AM', true])

        expect(service_hours.total_hours_annually).to eq 455
      end

      it 'will return 1235 hours when start time is 1AM and end time is 12:45 next day' do
        add_times_to_service_hours(['01', '00', 'AM'], ['12', '45', 'AM', true])

        expect(service_hours.total_hours_annually).to eq 1235
      end
    end

    context 'when service hours are over multiple days' do
      it 'will return 104 hours when there is a service requiring one hour for two days' do
        add_times_to_service_hours(['09', '00', 'AM'], ['10', '00', 'AM'])
        add_times_to_service_hours(['09', '00', 'AM'], ['10', '00', 'AM'], :tuesday)

        expect(service_hours.total_hours_annually).to eq 104
      end

      it 'will return 117 hours when there is a service requiring one and a quarter hours for one of two days' do
        add_times_to_service_hours(['09', '00', 'AM'], ['10', '15', 'AM'])
        add_times_to_service_hours(['09', '00', 'AM'], ['10', '00', 'AM'], :tuesday)

        expect(service_hours.total_hours_annually).to eq 117
      end

      it 'will return 130 hours when there is a service requiring one and a quarter hours for two days' do
        add_times_to_service_hours(['09', '00', 'AM'], ['10', '15', 'AM'])
        add_times_to_service_hours(['09', '00', 'AM'], ['10', '15', 'AM'], :tuesday)

        expect(service_hours.total_hours_annually).to eq 130
      end

      it 'will return 143 hours when there is a service requiring one and three quarter hours for one of two days' do
        add_times_to_service_hours(['09', '00', 'AM'], ['10', '45', 'AM'])
        add_times_to_service_hours(['09', '00', 'AM'], ['10', '00', 'AM'], :tuesday)

        expect(service_hours.total_hours_annually).to eq 143
      end

      it 'will return 182 hours when there is a service requiring one and three quarter hours for two days' do
        add_times_to_service_hours(['09', '00', 'AM'], ['10', '45', 'AM'])
        add_times_to_service_hours(['09', '00', 'AM'], ['10', '45', 'AM'], :tuesday)

        expect(service_hours.total_hours_annually).to eq 182
      end

      it 'will return 832 hours when there is a service requiring 8 hours for two days morning to afternoon' do
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '00', 'PM'])
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '00', 'PM'], :tuesday)

        expect(service_hours.total_hours_annually).to eq 832
      end

      it 'will return 832 hours when there is a service requiring 8 hours for two days afternoon to morning' do
        add_times_to_service_hours(['09', '00', 'PM'], ['05', '00', 'AM', true])
        add_times_to_service_hours(['09', '00', 'PM'], ['05', '00', 'AM', true], :tuesday)

        expect(service_hours.total_hours_annually).to eq 832
      end

      it 'will return 858 hours when there is a service requiring 8.25 hours for two days morning to afternoon' do
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '15', 'PM'])
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '15', 'PM'], :tuesday)

        expect(service_hours.total_hours_annually).to eq 858
      end

      it 'will return 884 hours when there is a service requiring 8.5 hours for two days afternoon to morning' do
        add_times_to_service_hours(['09', '00', 'PM'], ['05', '30', 'AM', true])
        add_times_to_service_hours(['09', '00', 'PM'], ['05', '30', 'AM', true], :tuesday)

        expect(service_hours.total_hours_annually).to eq 884
      end

      it 'will return 910 hours when there is a service requiring 8.75 hours for two days afternoon to morning' do
        add_times_to_service_hours(['09', '00', 'PM'], ['05', '45', 'AM', true])
        add_times_to_service_hours(['09', '00', 'PM'], ['05', '45', 'AM', true], :tuesday)

        expect(service_hours.total_hours_annually).to eq 910
      end
    end

    context 'when every day has service hours' do
      it 'will return 3744 hours when all the times are different' do
        add_times_to_service_hours(['09', '00', 'PM'], ['05', '45', 'AM', true], :monday)
        add_times_to_service_hours(['12', '00', 'AM'], ['05', '30', 'AM'], :tuesday)
        add_times_to_service_hours(['09', '00', 'PM'], ['05', '15', 'AM', true], :wednesday)
        add_times_to_service_hours(['06', '00', 'AM'], ['05', '00', 'PM'], :thursday)
        add_times_to_service_hours(['03', '00', 'PM'], ['04', '45', 'AM', true], :friday)
        add_times_to_service_hours(['01', '00', 'AM'], ['04', '30', 'PM'], :saturday)
        add_times_to_service_hours(['07', '00', 'PM'], ['04', '15', 'AM', true], :sunday)

        expect(service_hours.total_hours_annually).to eq 3744
      end

      it 'will return 2912 hours when all the times are the same' do
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '00', 'PM'], :monday)
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '00', 'PM'], :tuesday)
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '00', 'PM'], :wednesday)
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '00', 'PM'], :thursday)
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '00', 'PM'], :friday)
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '00', 'PM'], :saturday)
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '00', 'PM'], :sunday)

        expect(service_hours.total_hours_annually).to eq 2912
      end
    end

    context 'when the number of personnel is greater than 1' do
      it 'will return the correct answer when personnel is less than 5' do
        add_times_to_service_hours(['10', '00', 'AM'], ['11', '00', 'AM'])
        personnel = rand(1..5)
        service_hours[:personnel] = personnel

        expect(service_hours.total_hours_annually).to eq 52 * personnel
      end

      it 'will return the correct answer when personnel is less than 10' do
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '00', 'PM'], :monday)
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '00', 'PM'], :tuesday)
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '00', 'PM'], :wednesday)
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '00', 'PM'], :thursday)
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '00', 'PM'], :friday)
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '00', 'PM'], :saturday)
        add_times_to_service_hours(['09', '00', 'AM'], ['05', '00', 'PM'], :sunday)
        personnel = rand(6..10)
        service_hours[:personnel] = personnel

        expect(service_hours.total_hours_annually).to eq 2912 * personnel
      end

      it 'will return the correct answer when personnel is less than 20' do
        add_times_to_service_hours(['09', '00', 'AM'], ['10', '00', 'AM'])
        add_times_to_service_hours(['09', '00', 'AM'], ['10', '00', 'AM'], :tuesday)
        personnel = rand(11..20)
        service_hours[:personnel] = personnel

        expect(service_hours.total_hours_annually).to eq 104 * personnel
      end
    end
  end

  describe 'service hour validation' do
    before { service_hours[:personnel] = 1 }

    context 'when the times of consecutive days overlap' do
      context 'when Mon end time is 8 am next day and Tues start time is 6 am' do
        it 'is expected to not be valid and have the correct error message' do
          add_times_to_service_hours(['09', '00', 'AM'], ['08', '00', 'AM', true], :monday)
          add_times_to_service_hours(['06', '00', 'AM'], ['05', '00', 'PM'], :tuesday)

          expect(service_hours.valid?).to eq false
          expect(service_hours.attributes[:tuesday].errors[:start_time].first).to eq 'The start time of Tuesday cannot be earlier than the end time of the previous day'
        end
      end

      context 'when Wed end time is 6 pm next day and Thurs start time is 8 am' do
        it 'is expected to not be valid and have the correct error message' do
          add_times_to_service_hours(['11', '00', 'PM'], ['06', '00', 'PM', true], :wednesday)
          add_times_to_service_hours(['08', '00', 'AM'], ['05', '00', 'PM'], :thursday)

          expect(service_hours.valid?).to eq false
          expect(service_hours.attributes[:thursday].errors[:start_time].first).to eq 'The start time of Thursday cannot be earlier than the end time of the previous day'
        end
      end

      context 'when Fri end time is 1 am next day and Sat is all day' do
        it 'is expected to not be valid and have the correct error message' do
          add_times_to_service_hours(['11', '00', 'PM'], ['06', '00', 'PM', true], :friday)
          service_hours[:saturday][:service_choice] = :all_day

          expect(service_hours.valid?).to eq false
          expect(service_hours.attributes[:saturday].errors[:service_choice].first).to eq 'The start time of Saturday cannot be earlier than the end time of the previous day'
        end
      end
    end

    context 'when the time of a day is more than 24 hours' do
      context 'when Tues start time is 8 am and end time is 8:15 am next day' do
        it 'is expected to not be valid and have the correct error message' do
          add_times_to_service_hours(['08', '00', 'AM'], ['08', '15', 'AM', true], :tuesday)

          expect(service_hours.valid?).to eq false
          expect(service_hours.attributes[:tuesday].errors[:end_time].first).to eq 'The total service period for a day cannot be more than 24 hours'
        end
      end

      context 'when Thurs start time is 8 am and end time is 10 pm next day' do
        it 'is expected to not be valid and have the correct error message' do
          add_times_to_service_hours(['08', '00', 'AM'], ['10', '00', 'PM', true], :thursday)

          expect(service_hours.valid?).to eq false
          expect(service_hours.attributes[:thursday].errors[:end_time].first).to eq 'The total service period for a day cannot be more than 24 hours'
        end
      end

      context 'when Sat start time is 12 am and end time is 1 am next day' do
        it 'is expected to not be valid and have the correct error message' do
          add_times_to_service_hours(['12', '00', 'AM'], ['1', '00', 'AM', true], :saturday)

          expect(service_hours.valid?).to eq false
          expect(service_hours.attributes[:saturday].errors[:end_time].first).to eq 'The total service period for a day cannot be more than 24 hours'
        end
      end
    end

    context 'when Sat start time is 12 am and end time is 12 am' do
      it 'is expected to be valid when next day true' do
        add_times_to_service_hours(['12', '00', 'AM'], ['12', '00', 'AM', true], :saturday)

        expect(service_hours.valid?).to eq true
      end

      it 'is expected to be valid when next day false' do
        add_times_to_service_hours(['12', '00', 'AM'], ['12', '00', 'AM', false], :saturday)

        expect(service_hours.valid?).to eq true
      end
    end
  end

  describe 'service choice summary' do
    context 'when Monday is not required' do
      it 'will have the correct summary' do
        expect(service_hours.to_summary(:monday)).to eq 'Mon, not required'
      end
    end

    context 'when Tuesday is all day' do
      it 'will have the correct summary' do
        expect(service_hours.to_summary(:tuesday)).to eq 'Tue, all day (24 hours)'
      end
    end

    context 'when Wednesday is hourly' do
      it 'will have the correct summary' do
        expect(service_hours.to_summary(:wednesday)).to eq 'Wed, 8am to Wed, 5:30pm'
      end
    end

    context 'when Thursday is not required' do
      it 'will have the correct summary' do
        expect(service_hours.to_summary(:thursday)).to eq 'Thu, not required'
      end
    end

    context 'when Friday is all day' do
      it 'will have the correct summary' do
        expect(service_hours.to_summary(:friday)).to eq 'Fri, all day (24 hours)'
      end
    end

    context 'when Saturday is hourly' do
      it 'will have the correct summary' do
        expect(service_hours.to_summary(:saturday)).to eq 'Sat, 10am to Sat, 5:30pm'
      end
    end

    context 'when Sunday is not required' do
      it 'will have the correct summary' do
        expect(service_hours.to_summary(:sunday)).to eq 'Sun, not required'
      end
    end

    context 'when Sunday is hourly' do
      it 'will have the correct summary' do
        add_times_to_service_hours(['5', '00', 'PM'], ['7', '00', 'AM', true], :sunday)

        expect(service_hours.to_summary(:sunday)).to eq 'Sun, 5pm to Mon, 7am'
      end
    end

    context 'when Tuesday is hourly' do
      it 'will have the correct summary' do
        add_times_to_service_hours(['08', '00', 'PM'], ['07', '00', 'AM', true], :tuesday)

        expect(service_hours.to_summary(:tuesday)).to eq 'Tue, 8pm to Wed, 7am'
      end
    end
  end
end
