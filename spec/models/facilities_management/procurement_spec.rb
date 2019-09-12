require 'rails_helper'

RSpec.describe FacilitiesManagement::Procurement, type: :model do
  let(:user) { build(:user) }
  subject(:procurement) { build(:facilities_management_procurement, user: user) }

  it { is_expected.to be_valid }

  describe '#name' do
    context 'when the name is more than 100 characters' do
      it 'should not be valid' do
        procurement.name = (0...101).map { ('a'..'z').to_a[rand(26)] }.join

        expect(subject).to_not be_valid
      end
    end

    context 'when the name is not unique' do
      let(:second_procurement) {  build(:facilities_management_procurement, name: subject.name, user: user) }

      it 'should not be valid' do
        subject.save

        expect(second_procurement).to_not be_valid
      end
    end
  end
end
