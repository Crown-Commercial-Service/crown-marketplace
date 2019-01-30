require 'rails_helper'

RSpec.describe Login::BaseLogin, type: :model do
  subject(:login) do
    Login::BaseLogin.new(email: 'user@example.com', extra: {})
  end

  describe '#auth_provider' do
    it 'raises an exception' do
      expect { login.auth_provider }.to raise_error(RuntimeError, 'not implemented')
    end
  end

  describe '#logout_url' do
    it 'raises an exception' do
      expect { login.logout_url('') }.to raise_error(RuntimeError, 'not implemented')
    end
  end

  describe '#permit?' do
    it 'raises an exception' do
      expect { login.permit?(:supply_teachers) }.to raise_error(RuntimeError, 'not implemented')
    end
  end
end
