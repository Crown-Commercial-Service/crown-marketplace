require 'rails_helper'

RSpec.describe FacilitiesManagement::RM3830::ServiceQuestionsConcern do
  include described_class

  describe '#service_quesions' do
    context 'when service_questions is called' do
      it 'returns FacilitiesManagement::RM3830::ServicesAndQuestions' do
        expect(service_quesions).to be FacilitiesManagement::RM3830::ServicesAndQuestions
      end
    end
  end

  describe '#services_requiring_volumes' do
    let(:service_codes) { %w[C.5 E.4 G.1 G.3 K.1 K.2 K.3 K.4 K.5 K.6 K.7 H.4 I.1 H.5 I.2 I.3 I.4 J.1 J.2 J.3 J.4 J.5 J.6] }

    context 'when services_requiring_volumes is called' do
      it 'returns the correct service codes' do
        expect(services_requiring_volumes).to eq service_codes
      end
    end
  end

  describe '#services_requiring_service_standards' do
    let(:service_codes) { %w[C.5 G.1 G.3 G.5 C.1 C.2 C.3 C.4 C.6 C.7 C.11 C.12 C.13 C.14 G.4] }

    context 'when services_requiring_service_standards is called' do
      it 'returns the correct service codes' do
        expect(services_requiring_service_standards).to eq service_codes
      end
    end
  end

  describe '#services_requiring_service_hours' do
    let(:service_codes) { %w[H.4 I.1 H.5 I.2 I.3 I.4 J.1 J.2 J.3 J.4 J.5 J.6] }

    context 'when services_requiring_service_hours is called' do
      it 'returns the correct service codes' do
        expect(services_requiring_service_hours).to eq service_codes
      end
    end
  end

  describe '#services_requiring_gia' do
    let(:service_codes) { %w[C.1 C.10 C.11 C.12 C.13 C.14 C.15 C.16 C.17 C.18 C.2 C.20 C.3 C.4 C.6 C.7 C.8 C.9 E.1 E.2 E.3 E.5 E.6 E.7 E.8 F.1 G.10 G.11 G.14 G.15 G.16 G.2 G.4 G.6 G.7 G.9 H.1 H.10 H.11 H.13 H.2 H.3 H.6 H.7 H.8 H.9 J.10 J.11 J.7 J.9 L.2 L.3 L.4 L.5 G.1 G.3] }

    context 'when services_requiring_gia is called' do
      it 'returns the correct service codes' do
        expect(services_requiring_gia).to eq service_codes
      end
    end
  end

  describe '#services_requiring_external_area' do
    let(:service_codes) { ['G.5'] }

    context 'when services_requiring_external_area is called' do
      it 'returns the correct service codes' do
        expect(services_requiring_external_area).to eq service_codes
      end
    end
  end

  describe '#services_requiring_lift_data' do
    let(:service_codes) { ['C.5'] }

    context 'when services_requiring_lift_data is called' do
      it 'returns the correct service codes' do
        expect(services_requiring_lift_data).to eq service_codes
      end
    end
  end

  describe '#services_requiring_unit_of_measure' do
    let(:service_codes) { %w[C.5 E.4 G.1 G.3 K.1 K.2 K.3 K.4 K.5 K.6 K.7 H.4 I.1 H.5 I.2 I.3 I.4 J.1 J.2 J.3 J.4 J.5 J.6 C.1 C.10 C.11 C.12 C.13 C.14 C.15 C.16 C.17 C.18 C.2 C.20 C.3 C.4 C.6 C.7 C.8 C.9 E.1 E.2 E.3 E.5 E.6 E.7 E.8 F.1 G.10 G.11 G.14 G.15 G.16 G.2 G.4 G.6 G.7 G.9 H.1 H.10 H.11 H.13 H.2 H.3 H.6 H.7 H.8 H.9 J.10 J.11 J.7 J.9 L.2 L.3 L.4 L.5 G.5] }

    context 'when services_requiring_unit_of_measure is called' do
      it 'returns the correct service codes' do
        expect(services_requiring_unit_of_measure).to eq service_codes
      end
    end
  end

  describe '#services_requiring_questions' do
    let(:service_codes) { %w[C.5 E.4 G.1 G.3 K.1 K.2 K.3 K.4 K.5 K.6 K.7 H.4 I.1 H.5 I.2 I.3 I.4 J.1 J.2 J.3 J.4 J.5 J.6 C.1 C.10 C.11 C.12 C.13 C.14 C.15 C.16 C.17 C.18 C.2 C.20 C.3 C.4 C.6 C.7 C.8 C.9 E.1 E.2 E.3 E.5 E.6 E.7 E.8 F.1 G.10 G.11 G.14 G.15 G.16 G.2 G.4 G.6 G.7 G.9 H.1 H.10 H.11 H.13 H.2 H.3 H.6 H.7 H.8 H.9 J.10 J.11 J.7 J.9 L.2 L.3 L.4 L.5 G.5] }

    context 'when services_requiring_questions is called' do
      it 'returns the correct service codes' do
        expect(services_requiring_questions).to eq service_codes
      end
    end
  end

  describe '#volume_contexts' do
    let(:volume_contexts_list) { %i[no_of_appliances_for_testing no_of_building_occupants no_of_consoles_to_be_serviced tones_to_be_collected_and_removed no_of_units_to_be_serviced] }

    context 'when volume_contexts is called' do
      it 'returns the correct volume contexts' do
        expect(volume_contexts).to eq volume_contexts_list
      end
    end
  end
end
