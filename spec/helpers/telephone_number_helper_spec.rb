require 'rails_helper'

RSpec.describe TelephoneNumberHelper, type: :helper do
  describe '#format_telephone_number' do
    it 'adds spaces to a UK number' do
      expect(helper.format_telephone_number('01214960123'))
        .to eq('0121 496 0123')
    end

    it 'removes a standard international prefix from a UK number' do
      expect(helper.format_telephone_number('+441214960123'))
        .to eq('0121 496 0123')
    end

    it 'removes a folk international prefix from a UK number' do
      expect(helper.format_telephone_number('+44(0)1214960123'))
        .to eq('0121 496 0123')
    end

    it 'formats a non-UK number' do
      expect(helper.format_telephone_number('+35316711633'))
        .to eq('+353 1 671 1633')
    end

    it 'ignores padding' do
      expect(helper.format_telephone_number(' 01214960123 '))
        .to eq('0121 496 0123')
    end

    it 'returns an empty string for an empty input' do
      expect(helper.format_telephone_number(''))
        .to eq('')
    end

    it 'returns nil for a nil input' do
      expect(helper.format_telephone_number(nil))
        .to be_nil
    end

    it 'does not attempt to format non-numeric input' do
      expect(helper.format_telephone_number('N/A'))
        .to eq('N/A')
    end

    it 'does not change invalid numbers' do
      expect(helper.format_telephone_number('0121 496 0123 (option3)'))
        .to eq('0121 496 0123 (option3)')
    end
  end
end
