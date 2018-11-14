require 'rails_helper'

module TempToPermCalculator
  module Steps
    RSpec.describe Fee, type: :model do
      subject(:step) { described_class.new }

      it 'is the final step' do
        expect(step.final?).to be true
      end
    end
  end
end
