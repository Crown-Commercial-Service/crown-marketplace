require 'rails_helper'

RSpec.describe Journey, type: :model do
  subject :journey do
    Journey.new(first_step_class, slug, params, paths)
  end

  let(:params) { ActionController::Parameters.new }
  let(:paths) { instance_double('JourneyPaths') }

  context 'when created with a single step journey' do
    let :first_step_class do
      JourneyStep
    end

    let(:slug) { first_step_class.new.slug }

    describe '#first_step' do
      it 'returns the first step class' do
        expect(journey.first_step).to be_an_instance_of first_step_class
      end
    end

    describe '#current_step' do
      it 'is the same as the first step' do
        expect(journey.current_step).to eq(journey.first_step)
      end
    end

    describe '#previous_step' do
      it 'is nil' do
        expect(journey.previous_step).to be_nil
      end
    end

    describe '#next_step' do
      it 'is nil' do
        expect(journey.next_step).to be_nil
      end
    end

    describe '#first_step_path' do
      it 'returns the first step_s path' do
        allow(paths).to receive(:question)
          .with(slug)
          .and_return(:a_path)
        expect(journey.first_step_path).to eq(:a_path)
        expect(paths).to have_received(:question)
      end
    end

    describe '#current_step_path' do
      it 'returns the current step_s path' do
        allow(paths).to receive(:question)
          .with(slug, params)
          .and_return(:a_path)
        expect(journey.current_step_path).to eq(:a_path)
        expect(paths).to have_received(:question)
      end
    end

    describe '#previous_step_path' do
      it 'returns the start path' do
        allow(paths).to receive(:home)
          .and_return(:a_path)
        expect(journey.previous_step_path).to eq(:a_path)
        expect(paths).to have_received(:home)
      end
    end

    describe '#next_step_path' do
      it 'probably blows up, passes nil to path' do
        allow(paths).to receive(:question)
          .with(nil, params)
          .and_return(:a_path)
        expect(journey.next_step_path).to eq(:a_path)
        expect(paths).to have_received(:question)
      end
    end
  end

  class SecondStep < JourneyStep; end
  class FirstStep < JourneyStep
    def next_step_class
      SecondStep
    end
  end

  context 'when created with a two step journey' do
    let :first_step_class do
      FirstStep
    end

    context 'and on the first step' do
      let(:slug) { first_step_class.new.slug }

      describe '#first_step' do
        it 'returns a first step' do
          expect(journey.first_step).to be_an_instance_of first_step_class
        end
      end

      describe '#current_step' do
        it 'is the same as the first step' do
          expect(journey.current_step).to eq(journey.first_step)
        end
      end

      describe '#previous_step' do
        it 'is nil' do
          expect(journey.previous_step).to be_nil
        end
      end

      describe '#next_step' do
        it 'returns a second step' do
          expect(journey.next_step).to be_an_instance_of SecondStep
        end
      end

      describe '#first_step_path' do
        it 'returns the first step_s path' do
          allow(paths).to receive(:question)
            .with(slug)
            .and_return(:a_path)
          expect(journey.first_step_path).to eq(:a_path)
          expect(paths).to have_received(:question)
        end
      end

      describe '#current_step_path' do
        it 'returns the current step_s path' do
          allow(paths).to receive(:question)
            .with(slug, params)
            .and_return(:a_path)
          expect(journey.current_step_path).to eq(:a_path)
          expect(paths).to have_received(:question)
        end
      end

      describe '#previous_step_path' do
        it 'returns the start path' do
          allow(paths).to receive(:home)
            .and_return(:a_path)
          expect(journey.previous_step_path).to eq(:a_path)
          expect(paths).to have_received(:home)
        end
      end

      describe '#next_step_path' do
        it 'is the second step_s path' do
          allow(paths).to receive(:question)
            .with(SecondStep.new.slug, params)
            .and_return(:a_path)
          expect(journey.next_step_path).to eq(:a_path)
          expect(paths).to have_received(:question)
        end
      end
    end

    context 'and a slug does not match a step' do
      let(:slug) { 'not-a-slug' }

      describe '#current_step' do
        it 'is now the last step' do
          expect(journey.current_step).to be_an_instance_of SecondStep
        end
      end

      describe '#next_step' do
        it 'is nil' do
          expect(journey.next_step).to be_nil
        end
      end
    end

    context 'and on the second step' do
      let(:slug) { SecondStep.new.slug }

      describe '#first_step' do
        it 'returns an instance of the first_step_class' do
          expect(journey.first_step).to be_an_instance_of FirstStep
        end
      end

      describe '#current_step' do
        it 'is now the second step' do
          expect(journey.current_step).to be_an_instance_of SecondStep
        end
      end

      describe '#previous_step' do
        it 'is the first step' do
          expect(journey.previous_step).to be_an_instance_of FirstStep
        end
      end

      describe '#next_step' do
        it 'is nil' do
          expect(journey.next_step).to be_nil
        end
      end

      describe '#first_step_path' do
        it 'returns the first step path' do
          allow(paths).to receive(:question)
            .with(journey.first_step.slug)
            .and_return(:a_path)
          expect(journey.first_step_path).to eq(:a_path)
          expect(paths).to have_received(:question)
        end
      end

      describe '#current_step_path' do
        it 'returns the second step path' do
          allow(paths).to receive(:question)
            .with(slug, params)
            .and_return(:a_path)
          expect(journey.current_step_path).to eq(:a_path)
          expect(paths).to have_received(:question)
        end
      end

      describe '#previous_step_path' do
        it 'returns the first step path' do
          allow(paths).to receive(:question)
            .with(journey.first_step.slug, params)
            .and_return(:a_path)
          expect(journey.previous_step_path).to eq(:a_path)
          expect(paths).to have_received(:question)
        end
      end

      describe '#next_step_path' do
        it 'probably blows up, passes nil' do
          allow(paths).to receive(:question)
            .with(nil, params)
            .and_return(:a_path)
          expect(journey.next_step_path).to eq(:a_path)
          expect(paths).to have_received(:question)
        end
      end
    end
  end

  class ThirdValidStep < JourneyStep; end
  class SecondInvalidStep < JourneyStep
    def next_step_class
      ThirdValidStep
    end

    def valid?(_context = nil)
      false
    end
  end
  class FirstValidStep < JourneyStep
    def next_step_class
      SecondInvalidStep
    end
  end

  context 'when the second step is invalid' do
    let(:first_step_class) { FirstValidStep }
    let(:slug) { ThirdValidStep.new.slug }

    describe '#valid?' do
      it('is false') { expect(journey.valid?).to be false }
    end

    describe '#first_step' do
      it 'is the first step' do
        expect(journey.first_step).to be_an_instance_of FirstValidStep
      end
    end

    describe '#current_step' do
      it 'is now the second step' do
        expect(journey.current_step).to be_an_instance_of SecondInvalidStep
      end
    end

    describe '#previous_step' do
      it 'is the first step' do
        expect(journey.previous_step).to be_an_instance_of FirstValidStep
      end
    end

    describe '#next_step' do
      it 'is an instance of third step' do
        expect(journey.next_step).to be_an_instance_of ThirdValidStep
      end
    end
  end
end
