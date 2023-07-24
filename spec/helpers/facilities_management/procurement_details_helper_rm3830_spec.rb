require 'rails_helper'

RSpec.describe FacilitiesManagement::ProcurementDetailsHelper do
  describe '.initial_call_off_period_error?' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings) }

    before { @procurement = procurement }

    context 'when there are no errors' do
      it 'returns false' do
        expect(helper.initial_call_off_period_error?).to be false
      end
    end

    context 'when there are errors on initial_call_off_period_years' do
      before { procurement.errors.add(:initial_call_off_period_years, :blank) }

      it 'returns true' do
        expect(helper.initial_call_off_period_error?).to be true
      end
    end

    context 'when there are errors on initial_call_off_period_months' do
      before { procurement.errors.add(:initial_call_off_period_months, :less_than_or_equal_to) }

      it 'returns true' do
        expect(helper.initial_call_off_period_error?).to be true
      end
    end

    context 'when there are errors on base' do
      context 'and it is not total_contract_period' do
        before { procurement.errors.add(:base, :services_not_present) }

        it 'returns false' do
          expect(helper.initial_call_off_period_error?).to be false
        end
      end

      context 'and it is total_contract_period' do
        before { procurement.errors.add(:base, :total_contract_period) }

        it 'returns true' do
          expect(helper.initial_call_off_period_error?).to be true
        end
      end
    end
  end

  describe '.extension_periods_error?' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings) }
    let(:extensions_required) { true }
    let(:years) { 1 }
    let(:months) { 1 }

    before do
      procurement.assign_attributes(extensions_required: extensions_required,
                                    call_off_extensions_attributes: { '0': {
                                      years: years,
                                      months: months,
                                      extension: 0,
                                      extension_required: 'true'
                                    } })
      procurement.valid?(:contract_period)
      @procurement = procurement
    end

    context 'when there are no errors' do
      it 'returns false' do
        expect(helper.extension_periods_error?).to be false
      end
    end

    context 'when there are no errors related to the extension period' do
      before { procurement.errors.add(:mobilisation_period, :blank) }

      it 'returns false' do
        expect(helper.extension_periods_error?).to be false
      end
    end

    context 'when there are errors on extensions_required' do
      let(:extensions_required) { nil }

      it 'returns true' do
        expect(helper.extension_periods_error?).to be true
      end
    end

    context 'when there are errors on call_off_extensions.months' do
      let(:months) { nil }

      it 'returns true' do
        expect(helper.extension_periods_error?).to be true
      end
    end

    context 'when there are errors on call_off_extensions.years' do
      let(:years) { nil }

      it 'returns true' do
        expect(helper.extension_periods_error?).to be true
      end
    end

    context 'when there are errors on call_off_extensions' do
      let(:months) { 0 }
      let(:years) { 0 }

      it 'returns true' do
        expect(helper.extension_periods_error?).to be true
      end
    end
  end

  describe '.total_contract_length_error?' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings) }

    before { @procurement = procurement }

    context 'when there are no errors' do
      it 'returns false' do
        expect(helper.total_contract_length_error?).to be false
      end
    end

    context 'when there are no errors on base' do
      before { procurement.errors.add(:initial_call_off_period_years, :blank) }

      it 'returns true' do
        expect(helper.total_contract_length_error?).to be false
      end
    end

    context 'when there are errors on base' do
      context 'and it is not total_contract_length' do
        before { procurement.errors.add(:base, :total_contract_period) }

        it 'returns false' do
          expect(helper.total_contract_length_error?).to be false
        end
      end

      context 'and it is total_contract_length' do
        before { procurement.errors.add(:base, :total_contract_length) }

        it 'returns true' do
          expect(helper.total_contract_length_error?).to be true
        end
      end
    end
  end

  describe '.display_extension_error_anchor' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings) }
    let(:years) { 1 }
    let(:months) { 1 }

    before do
      procurement.assign_attributes(extensions_required: true,
                                    call_off_extensions_attributes: { '0': {
                                      years: years,
                                      months: months,
                                      extension: 0,
                                      extension_required: 'true'
                                    } })
      procurement.valid?(:contract_period)
      @procurement = procurement
    end

    context 'when there are no errors' do
      it 'returns an empty array' do
        expect(helper.display_extension_error_anchor).to eq []
      end
    end

    context 'when there are no errors related to the extension period' do
      before { procurement.errors.add(:initial_call_off_period_months, :blank) }

      it 'returns an empty array' do
        expect(helper.display_extension_error_anchor).to eq []
      end
    end

    context 'when there are errors on call_off_extensions.months' do
      let(:months) { nil }

      it 'returns an array with months-error' do
        expect(helper.display_extension_error_anchor).to eq ['call_off_extensions.months-error']
      end
    end

    context 'when there are errors on call_off_extensions.years' do
      let(:years) { nil }

      it 'returns an array with years-error' do
        expect(helper.display_extension_error_anchor).to eq ['call_off_extensions.years-error']
      end
    end

    context 'when there are errors on call_off_extensions' do
      let(:months) { 0 }
      let(:years) { 0 }

      it 'returns an array with -error' do
        expect(helper.display_extension_error_anchor).to eq ['call_off_extensions-error']
      end
    end
  end

  describe '.call_off_extensions' do
    let(:call_off_extension1) { procurement.call_off_extensions.create(extension: 2, years: 1, months: 1) }
    let(:call_off_extension2) { procurement.call_off_extensions.create(extension: 0, years: 1, months: 1) }
    let(:call_off_extension3) { procurement.call_off_extensions.create(extension: 3, years: 1, months: 1) }
    let(:call_off_extension4) { procurement.call_off_extensions.create(extension: 1, years: 1, months: 1) }
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings) }

    before do
      call_off_extension1
      call_off_extension2
      call_off_extension3
      call_off_extension4
      @procurement = procurement
    end

    it 'returns the call_off_extensions in the right order' do
      expect(helper.call_off_extensions).to eq [call_off_extension2, call_off_extension4, call_off_extension1, call_off_extension3]
    end
  end

  describe '.call_off_extension_visible?' do
    let(:extensions_required) { true }
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings, extensions_required:) }
    let(:result) { helper.call_off_extension_visible?(0) }

    before { @procurement = procurement }

    context 'when extensions are not required' do
      let(:extensions_required) { false }

      it 'returns false' do
        expect(result).to be false
      end
    end

    context 'when the extension does not exist' do
      it 'returns false' do
        expect(result).to be false
      end
    end

    context 'when the extension exists' do
      let(:extension_required) { nil }
      let(:years) { nil }
      let(:months) { nil }
      let(:call_off_extension) { create(:facilities_management_rm3830_procurement_call_off_extension, years:, months:, extension_required:) }

      before { procurement.update(call_off_extensions: [call_off_extension]) }

      context 'when no conditions are met' do
        it 'returns false' do
          expect(result).to be false
        end
      end

      context 'when the extension is required' do
        let(:extension_required) { true }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'when the extension years are present' do
        let(:years) { 1 }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'when the extension months are present' do
        let(:months) { 1 }

        it 'returns true' do
          expect(result).to be true
        end
      end

      context 'when the extension has errors' do
        before { call_off_extension.errors.add(:years, :blank) }

        it 'returns true' do
          expect(result).to be true
        end
      end
    end
  end

  describe '.new_building_path' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings) }

    before do
      helper.params[:framework] = 'RM3830'
      helper.params[:procurement_id] = procurement.id
    end

    it 'returns the new building path' do
      expect(helper.new_building_path).to eq "/facilities-management/RM3830/procurements/#{procurement.id}/edit-buildings/new"
    end
  end

  describe '.show_building_path' do
    let(:procurement) { create(:facilities_management_rm3830_procurement_no_procurement_buildings) }
    let(:building) { create(:facilities_management_building) }

    before do
      helper.params[:framework] = 'RM3830'
      helper.params[:procurement_id] = procurement.id
    end

    it 'returns the show building path' do
      expect(helper.show_building_path(building.id)).to eq "/facilities-management/RM3830/procurements/#{procurement.id}/edit-buildings/#{building.id}"
    end
  end
end
