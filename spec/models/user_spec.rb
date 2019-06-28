require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user, confirmed_at: confirmed_at) }

  describe '#confirmed?' do
    context 'when confirmed_at blank' do
      let(:confirmed_at) { nil }

      it 'returns false' do
        expect(user.confirmed?).to eq false
      end
    end

    context 'when confirmed_at is a date' do
      let(:confirmed_at) { Time.zone.now }

      it 'returns true' do
        expect(user.confirmed?).to eq true
      end
    end
  end
end
