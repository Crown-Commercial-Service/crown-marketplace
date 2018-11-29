require 'rails_helper'

RSpec.describe TempToPermCalculator::Journey::Fee, type: :model do
  subject(:step) { described_class.new }

  it 'is the final step' do
    expect(step.final?).to be true
  end
end
