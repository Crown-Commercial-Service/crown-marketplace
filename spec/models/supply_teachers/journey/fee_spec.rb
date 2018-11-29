require 'rails_helper'

RSpec.describe SupplyTeachers::Journey::Fee, type: :model do
  subject(:step) { described_class.new }

  it 'is the final step' do
    expect(step.final?).to be true
  end
end
