require 'rails_helper'

RSpec.describe ChangeLog do
  describe 'associations' do
    let(:change_log) { create(:change_log) }

    it { is_expected.to belong_to(:framework) }
    it { is_expected.to belong_to(:user) }

    it 'has the framework relationship' do
      expect(change_log.framework).to be_present
    end

    it 'has the user relationship' do
      expect(change_log.user).to be_present
    end
  end

  describe 'change_types' do
    it 'matches the expected change types' do
      expect(described_class::CHANGE_TYPES.keys).to eq(%i[upload_supplier_data update_supplier_information update_supplier_contact_information update_supplier_additional_information update_supplier_framework_lot_status update_supplier_framework_lot_services update_supplier_framework_lot_jurisdictions update_supplier_framework_lot_rates update_supplier_framework_lot_branch add_rates_for_supplier_framework_lot_jurisdiction remove_rates_for_supplier_framework_lot_jurisdiction])
      expect(described_class::CHANGE_TYPES.values).to eq(%w[upload_supplier_data update_supplier_information update_supplier_contact_information update_supplier_additional_information update_supplier_framework_lot_status update_supplier_framework_lot_services update_supplier_framework_lot_jurisdictions update_supplier_framework_lot_rates update_supplier_framework_lot_branch add_rates_for_supplier_framework_lot_jurisdiction remove_rates_for_supplier_framework_lot_jurisdiction])
    end

    context 'when trying to save a change type that is not in the list' do
      let(:change_log) { build(:change_log, change_type: Faker::String.random(length: 3..12)) }

      it 'is not valid' do
        expect(change_log).not_to be_valid
        expect(change_log.errors[:change_type]).to be_present
      end

      it 'returns false when saving' do
        expect(change_log.save).to be(false)
        expect(change_log.errors[:change_type]).to be_present
      end
    end
  end

  describe '.short_id' do
    let(:change_log) { create(:change_log) }

    it 'returns the shortened uuid' do
      expect(change_log.short_id).to eq("##{change_log.id[..7]}")
    end
  end

  describe '.changed_by' do
    let(:user) { create(:user) }
    let(:change_log) { create(:change_log, user:) }

    it 'returns the user email' do
      expect(change_log.changed_by).to eq(user.email)
    end
  end

  shared_examples 'when testing a change type' do
    it 'creates the change log' do
      expect { change_log }.to change(described_class, :count).by(1)
    end

    it 'has the right user' do
      expect(change_log.user).to eq(user)
    end

    it 'has the right framework' do
      expect(change_log.framework_id).to eq(framework_id)
    end

    it 'has the right change type' do
      expect(change_log.change_type).to eq(change_type)
    end

    it 'has the right change data' do
      expect(change_log.change_data).to eq(expected_change_data)
    end
  end

  describe '.log_upload_supplier_data!' do
    let(:user) { create(:user) }
    let(:framework_id) { 'RM6378' }
    let(:admin_upload) { create(:facilities_management_rm6378_admin_upload, user:) }
    let(:supplier_data) { { 'tv' => 'The Rookie' } }
    let(:change_type) { 'upload_supplier_data' }
    let(:change_log) { described_class.log_upload_supplier_data!(admin_upload:, supplier_data:) }
    let(:expected_change_data) { { 'admin_upload_id' => admin_upload.id, 'supplier_data' => supplier_data } }

    include_context 'when testing a change type'
  end

  describe '.log_update_supplier_information!' do
    let(:user) { create(:user) }
    let(:framework_id) { 'RM6360' }
    let(:supplier_attributes) { { name: 'Wario', duns_number: '123456789', sme: true } }
    let(:supplier) { create(:supplier, **supplier_attributes) }
    let(:change_type) { 'update_supplier_information' }
    let(:change_log) { described_class.log_update_supplier_information!(user: user, framework: framework_id, model: supplier) }

    before do
      supplier.assign_attributes(supplier_updates)
      supplier.save!
    end

    context 'when all attributes are updated' do
      let(:supplier_updates) { { name: 'Mario', duns_number: '987654321', sme: false } }
      let(:expected_change_data) { { 'id' => supplier.id, 'supplier_name' => 'Mario', 'before' => { 'name' => 'Wario', 'duns_number' => '123456789', 'sme' => true }, 'after' => { 'name' => 'Mario', 'duns_number' => '987654321', 'sme' => false } } }

      include_context 'when testing a change type'
    end

    context 'when some attributes are updated' do
      let(:supplier_updates) { { name: 'Mario', duns_number: '123456789', sme: true } }
      let(:expected_change_data) { { 'id' => supplier.id, 'supplier_name' => 'Mario', 'before' => { 'name' => 'Wario' }, 'after' => { 'name' => 'Mario' } } }

      include_context 'when testing a change type'
    end

    context 'when no attributes are updated' do
      let(:supplier_updates) { { name: 'Wario', duns_number: '123456789', sme: true } }

      it 'does not create a change log' do
        expect { change_log }.not_to change(described_class, :count)
      end
    end

    context 'when the supplier only has some supplier attributes' do
      let(:supplier_attributes) { { name: 'Wario' } }

      context 'when all attributes are updated' do
        let(:supplier_updates) { { name: 'Mario' } }
        let(:expected_change_data) { { 'id' => supplier.id, 'supplier_name' => 'Mario', 'before' => { 'name' => 'Wario' }, 'after' => { 'name' => 'Mario' } } }

        include_context 'when testing a change type'
      end

      context 'when no attributes are updated' do
        let(:supplier_updates) { { name: 'Wario' } }

        it 'does not create a change log' do
          expect { change_log }.not_to change(described_class, :count)
        end
      end
    end

    context 'when the supplier has additional attributes' do
      let(:supplier_attributes) { { name: 'Wario', trading_name: 'WarioWare', additional_identifier: '456654' } }

      context 'when all attributes are updated' do
        let(:supplier_updates) { { name: 'Mario', trading_name: 'Mario Bros.', additional_identifier: '654456' } }
        let(:expected_change_data) { { 'id' => supplier.id, 'supplier_name' => 'Mario', 'before' => { 'name' => 'Wario', 'additional_details' => { 'trading_name' => 'WarioWare', 'additional_identifier' => '456654' } }, 'after' => { 'name' => 'Mario', 'additional_details' => { 'trading_name' => 'Mario Bros.', 'additional_identifier' => '654456' } } } }

        include_context 'when testing a change type'
      end

      context 'when some attributes are updated' do
        let(:supplier_updates) { { name: 'Wario', trading_name: 'Mario Bros.', additional_identifier: '456654' } }
        let(:expected_change_data) { { 'id' => supplier.id, 'supplier_name' => 'Wario', 'before' => { 'additional_details' => { 'trading_name' => 'WarioWare' } }, 'after' => { 'additional_details' => { 'trading_name' => 'Mario Bros.' } } } }

        include_context 'when testing a change type'
      end

      context 'when all attributes are updated and some did not exist before' do
        let(:supplier_attributes) { { name: 'Wario' } }
        let(:supplier_updates) { { name: 'Mario', trading_name: 'Mario Bros.', additional_identifier: '654456' } }
        let(:expected_change_data) { { 'id' => supplier.id, 'supplier_name' => 'Mario', 'before' => { 'name' => 'Wario', 'additional_details' => {} }, 'after' => { 'name' => 'Mario', 'additional_details' => { 'trading_name' => 'Mario Bros.', 'additional_identifier' => '654456' } } } }

        include_context 'when testing a change type'
      end

      context 'when no attributes are updated' do
        let(:supplier_updates) { { name: 'Wario', trading_name: 'WarioWare', additional_identifier: '456654' } }

        it 'does not create a change log' do
          expect { change_log }.not_to change(described_class, :count)
        end
      end
    end
  end

  describe '.log_update_supplier_contact_information!' do
    let(:user) { create(:user) }
    let(:framework_id) { 'RM6360' }
    let(:supplier) { create(:supplier, name: 'Wario') }
    let(:supplier_framework) { create(:supplier_framework, framework_id:, supplier:) }
    let(:supplier_contact_information) { create(:supplier_framework_contact_detail, supplier_framework:, **supplier_contact_information_attributes) }
    let(:supplier_contact_information_attributes) { { name: 'Wario', email: 'wario@warioware.com', telephone_number: '07123456789', website: 'www.wario.example.com' } }
    let(:change_type) { 'update_supplier_contact_information' }
    let(:change_log) { described_class.log_update_supplier_contact_information!(user: user, framework: framework_id, model: supplier_contact_information) }

    before do
      supplier_contact_information.assign_attributes(supplier_contact_information_updates)
      supplier_contact_information.save!
    end

    context 'when all attributes are updated' do
      let(:supplier_contact_information_updates) { { name: 'Mario', email: 'mario@mariobros.com', telephone_number: '07987654321', website: 'www.mario.example.com' } }
      let(:expected_change_data) { { 'id' => supplier_contact_information.id, 'supplier_name' => 'Wario', 'before' => { 'name' => 'Wario', 'email' => 'wario@warioware.com', 'telephone_number' => '07123456789', 'website' => 'www.wario.example.com' }, 'after' => { 'name' => 'Mario', 'email' => 'mario@mariobros.com', 'telephone_number' => '07987654321', 'website' => 'www.mario.example.com' } } }

      include_context 'when testing a change type'
    end

    context 'when some attributes are updated' do
      let(:supplier_contact_information_updates) { { name: 'Wario', email: 'mario@mariobros.com', telephone_number: '07123456789', website: 'www.mario.example.com' } }
      let(:expected_change_data) { { 'id' => supplier_contact_information.id, 'supplier_name' => 'Wario', 'before' => { 'email' => 'wario@warioware.com', 'website' => 'www.wario.example.com' }, 'after' => { 'email' => 'mario@mariobros.com', 'website' => 'www.mario.example.com' } } }

      include_context 'when testing a change type'
    end

    context 'when no attributes are updated' do
      let(:supplier_contact_information_updates) { { name: 'Wario', email: 'wario@warioware.com', telephone_number: '07123456789', website: 'www.wario.example.com' } }

      it 'does not create a change log' do
        expect { change_log }.not_to change(described_class, :count)
      end
    end

    context 'when the supplier only has some supplier attributes' do
      let(:supplier_contact_information_attributes) { { email: 'wario@warioware.com', telephone_number: '07123456789', website: 'www.wario.example.com' } }

      context 'when all attributes are updated' do
        let(:supplier_contact_information_updates) { { email: 'mario@mariobros.com', telephone_number: '07987654321', website: 'www.mario.example.com' } }
        let(:expected_change_data) { { 'id' => supplier_contact_information.id, 'supplier_name' => 'Wario', 'before' => { 'email' => 'wario@warioware.com', 'telephone_number' => '07123456789', 'website' => 'www.wario.example.com' }, 'after' => { 'email' => 'mario@mariobros.com', 'telephone_number' => '07987654321', 'website' => 'www.mario.example.com' } } }

        include_context 'when testing a change type'
      end

      context 'when some attributes are updated' do
        let(:supplier_contact_information_updates) { { email: 'mario@mariobros.com', telephone_number: '07123456789', website: 'www.mario.example.com' } }
        let(:expected_change_data) { { 'id' => supplier_contact_information.id, 'supplier_name' => 'Wario', 'before' => { 'email' => 'wario@warioware.com', 'website' => 'www.wario.example.com' }, 'after' => { 'email' => 'mario@mariobros.com', 'website' => 'www.mario.example.com' } } }

        include_context 'when testing a change type'
      end

      context 'when no attributes are updated' do
        let(:supplier_contact_information_updates) { { email: 'wario@warioware.com', telephone_number: '07123456789', website: 'www.wario.example.com' } }

        it 'does not create a change log' do
          expect { change_log }.not_to change(described_class, :count)
        end
      end
    end
  end

  describe '.log_update_supplier_additional_information!' do
    let(:user) { create(:user) }
    let(:framework_id) { 'RM6360' }
    let(:supplier) { create(:supplier, name: 'Wario') }
    let(:supplier_framework) { create(:supplier_framework, framework_id:, supplier:) }
    let(:supplier_contact_information) { create(:supplier_framework_contact_detail, supplier_framework:, **supplier_contact_information_attributes) }
    let(:supplier_contact_information_attributes) { { address: 'WarioWare, Inc. Headquarters, Diamond City', lot_1_prospectus_link: 'https://warioware.example.com/investors/microgame-development', lot_2_prospectus_link: 'https://warioware.example.com/investors/garlic-farms-and-acquisitions', lot_3_prospectus_link: 'https://warioware.example.com/investors/treasure-hunting-expeditions', lot_4a_prospectus_link: 'https://warioware.example.com/investors/custom-motorcycle-rd', lot_4b_prospectus_link: 'https://warioware.example.com/investors/bomb-disposal-tech', lot_4c_prospectus_link: 'https://warioware.example.com/investors/nose-picking-innovations', lot_5_prospectus_link: 'https://warioware.example.com/investors/wah-crypto-holdings', managed_service_provider_name: 'WarioWare, Inc. Enterprise Solutions', managed_service_provider_telephone: '1-800-WAH-HAHA', managed_service_provider_email: 'gimmecoins@warioware.example.com' } }
    let(:change_type) { 'update_supplier_additional_information' }
    let(:change_log) { described_class.log_update_supplier_additional_information!(user: user, framework: framework_id, model: supplier_contact_information) }

    before do
      supplier_contact_information.assign_attributes(supplier_contact_information_updates)
      supplier_contact_information.save!
    end

    context 'when all attributes are updated' do
      let(:supplier_contact_information_updates) { { address: 'Mario Bros. Plumbing, 123 Mushroom Way, Toad Town, Mushroom Kingdom', lot_1_prospectus_link: 'https://mario-plumbing.example.com/prospectus/warp-pipe-maintenance', lot_2_prospectus_link: 'https://mario-plumbing.example.com/prospectus/goomba-and-koopa-removal', lot_3_prospectus_link: 'https://mario-plumbing.example.com/prospectus/princess-rescue-operations', lot_4a_prospectus_link: 'https://mario-kart.example.com/prospectus/anti-gravity-mechanics', lot_4b_prospectus_link: 'https://mario-kart.example.com/prospectus/blue-shell-defense-strategies', lot_4c_prospectus_link: 'https://mario-kart.example.com/prospectus/rainbow-road-navigation', lot_5_prospectus_link: 'https://mario-party.example.com/prospectus/power-star-acquisitions', managed_service_provider_name: 'Super Mario Bros. Managed Services', managed_service_provider_telephone: '1-800-ITS-A-MEE', managed_service_provider_email: 'mario.jumpman@mushroomkingdom.example.com' } }
      let(:expected_change_data) { { 'id' => supplier_contact_information.id, 'supplier_name' => 'Wario', 'before' => { 'additional_details' => { 'address' => 'WarioWare, Inc. Headquarters, Diamond City', 'lot_1_prospectus_link' => 'https://warioware.example.com/investors/microgame-development', 'lot_2_prospectus_link' => 'https://warioware.example.com/investors/garlic-farms-and-acquisitions', 'lot_3_prospectus_link' => 'https://warioware.example.com/investors/treasure-hunting-expeditions', 'lot_4a_prospectus_link' => 'https://warioware.example.com/investors/custom-motorcycle-rd', 'lot_4b_prospectus_link' => 'https://warioware.example.com/investors/bomb-disposal-tech', 'lot_4c_prospectus_link' => 'https://warioware.example.com/investors/nose-picking-innovations', 'lot_5_prospectus_link' => 'https://warioware.example.com/investors/wah-crypto-holdings', 'managed_service_provider_name' => 'WarioWare, Inc. Enterprise Solutions', 'managed_service_provider_telephone' => '1-800-WAH-HAHA', 'managed_service_provider_email' => 'gimmecoins@warioware.example.com' } }, 'after' => { 'additional_details' => { 'address' => 'Mario Bros. Plumbing, 123 Mushroom Way, Toad Town, Mushroom Kingdom', 'lot_1_prospectus_link' => 'https://mario-plumbing.example.com/prospectus/warp-pipe-maintenance', 'lot_2_prospectus_link' => 'https://mario-plumbing.example.com/prospectus/goomba-and-koopa-removal', 'lot_3_prospectus_link' => 'https://mario-plumbing.example.com/prospectus/princess-rescue-operations', 'lot_4a_prospectus_link' => 'https://mario-kart.example.com/prospectus/anti-gravity-mechanics', 'lot_4b_prospectus_link' => 'https://mario-kart.example.com/prospectus/blue-shell-defense-strategies', 'lot_4c_prospectus_link' => 'https://mario-kart.example.com/prospectus/rainbow-road-navigation', 'lot_5_prospectus_link' => 'https://mario-party.example.com/prospectus/power-star-acquisitions', 'managed_service_provider_name' => 'Super Mario Bros. Managed Services', 'managed_service_provider_telephone' => '1-800-ITS-A-MEE', 'managed_service_provider_email' => 'mario.jumpman@mushroomkingdom.example.com' } } } }

      include_context 'when testing a change type'
    end

    context 'when some attributes are updated' do
      let(:supplier_contact_information_updates) { { lot_1_prospectus_link: 'https://mario-plumbing.example.com/prospectus/warp-pipe-maintenance', lot_3_prospectus_link: 'https://mario-plumbing.example.com/prospectus/princess-rescue-operations', lot_4b_prospectus_link: 'https://mario-kart.example.com/prospectus/blue-shell-defense-strategies', lot_5_prospectus_link: 'https://mario-party.example.com/prospectus/power-star-acquisitions', managed_service_provider_telephone: '1-800-ITS-A-MEE' } }
      let(:expected_change_data) { { 'id' => supplier_contact_information.id, 'supplier_name' => 'Wario', 'before' => { 'additional_details' => { 'lot_1_prospectus_link' => 'https://warioware.example.com/investors/microgame-development', 'lot_3_prospectus_link' => 'https://warioware.example.com/investors/treasure-hunting-expeditions', 'lot_4b_prospectus_link' => 'https://warioware.example.com/investors/bomb-disposal-tech', 'lot_5_prospectus_link' => 'https://warioware.example.com/investors/wah-crypto-holdings', 'managed_service_provider_telephone' => '1-800-WAH-HAHA' } }, 'after' => { 'additional_details' => { 'lot_1_prospectus_link' => 'https://mario-plumbing.example.com/prospectus/warp-pipe-maintenance', 'lot_3_prospectus_link' => 'https://mario-plumbing.example.com/prospectus/princess-rescue-operations', 'lot_4b_prospectus_link' => 'https://mario-kart.example.com/prospectus/blue-shell-defense-strategies', 'lot_5_prospectus_link' => 'https://mario-party.example.com/prospectus/power-star-acquisitions', 'managed_service_provider_telephone' => '1-800-ITS-A-MEE' } } } }

      include_context 'when testing a change type'
    end

    context 'when all attributes are updated and some did not exist before' do
      let(:supplier_contact_information_attributes) { { lot_1_prospectus_link: 'https://warioware.example.com/investors/microgame-development', lot_2_prospectus_link: 'https://warioware.example.com/investors/garlic-farms-and-acquisitions', lot_3_prospectus_link: 'https://warioware.example.com/investors/treasure-hunting-expeditions', lot_4a_prospectus_link: 'https://warioware.example.com/investors/custom-motorcycle-rd', lot_4b_prospectus_link: 'https://warioware.example.com/investors/bomb-disposal-tech', lot_4c_prospectus_link: 'https://warioware.example.com/investors/nose-picking-innovations', lot_5_prospectus_link: 'https://warioware.example.com/investors/wah-crypto-holdings', managed_service_provider_name: 'WarioWare, Inc. Enterprise Solutions', managed_service_provider_telephone: '1-800-WAH-HAHA', managed_service_provider_email: 'gimmecoins@warioware.example.com' } }
      let(:supplier_contact_information_updates) { { address: 'Mario Bros. Plumbing, 123 Mushroom Way, Toad Town, Mushroom Kingdom', lot_1_prospectus_link: 'https://mario-plumbing.example.com/prospectus/warp-pipe-maintenance', lot_2_prospectus_link: 'https://mario-plumbing.example.com/prospectus/goomba-and-koopa-removal', lot_3_prospectus_link: 'https://mario-plumbing.example.com/prospectus/princess-rescue-operations', lot_4a_prospectus_link: 'https://mario-kart.example.com/prospectus/anti-gravity-mechanics', lot_4b_prospectus_link: 'https://mario-kart.example.com/prospectus/blue-shell-defense-strategies', lot_4c_prospectus_link: 'https://mario-kart.example.com/prospectus/rainbow-road-navigation', lot_5_prospectus_link: 'https://mario-party.example.com/prospectus/power-star-acquisitions', managed_service_provider_name: 'Super Mario Bros. Managed Services', managed_service_provider_telephone: '1-800-ITS-A-MEE', managed_service_provider_email: 'mario.jumpman@mushroomkingdom.example.com' } }
      let(:expected_change_data) { { 'id' => supplier_contact_information.id, 'supplier_name' => 'Wario', 'before' => { 'additional_details' => { 'lot_1_prospectus_link' => 'https://warioware.example.com/investors/microgame-development', 'lot_2_prospectus_link' => 'https://warioware.example.com/investors/garlic-farms-and-acquisitions', 'lot_3_prospectus_link' => 'https://warioware.example.com/investors/treasure-hunting-expeditions', 'lot_4a_prospectus_link' => 'https://warioware.example.com/investors/custom-motorcycle-rd', 'lot_4b_prospectus_link' => 'https://warioware.example.com/investors/bomb-disposal-tech', 'lot_4c_prospectus_link' => 'https://warioware.example.com/investors/nose-picking-innovations', 'lot_5_prospectus_link' => 'https://warioware.example.com/investors/wah-crypto-holdings', 'managed_service_provider_name' => 'WarioWare, Inc. Enterprise Solutions', 'managed_service_provider_telephone' => '1-800-WAH-HAHA', 'managed_service_provider_email' => 'gimmecoins@warioware.example.com' } }, 'after' => { 'additional_details' => { 'address' => 'Mario Bros. Plumbing, 123 Mushroom Way, Toad Town, Mushroom Kingdom', 'lot_1_prospectus_link' => 'https://mario-plumbing.example.com/prospectus/warp-pipe-maintenance', 'lot_2_prospectus_link' => 'https://mario-plumbing.example.com/prospectus/goomba-and-koopa-removal', 'lot_3_prospectus_link' => 'https://mario-plumbing.example.com/prospectus/princess-rescue-operations', 'lot_4a_prospectus_link' => 'https://mario-kart.example.com/prospectus/anti-gravity-mechanics', 'lot_4b_prospectus_link' => 'https://mario-kart.example.com/prospectus/blue-shell-defense-strategies', 'lot_4c_prospectus_link' => 'https://mario-kart.example.com/prospectus/rainbow-road-navigation', 'lot_5_prospectus_link' => 'https://mario-party.example.com/prospectus/power-star-acquisitions', 'managed_service_provider_name' => 'Super Mario Bros. Managed Services', 'managed_service_provider_telephone' => '1-800-ITS-A-MEE', 'managed_service_provider_email' => 'mario.jumpman@mushroomkingdom.example.com' } } } }

      include_context 'when testing a change type'
    end

    context 'when no attributes are updated' do
      let(:supplier_contact_information_updates) { { address: 'WarioWare, Inc. Headquarters, Diamond City', lot_1_prospectus_link: 'https://warioware.example.com/investors/microgame-development', lot_2_prospectus_link: 'https://warioware.example.com/investors/garlic-farms-and-acquisitions', lot_3_prospectus_link: 'https://warioware.example.com/investors/treasure-hunting-expeditions', lot_4a_prospectus_link: 'https://warioware.example.com/investors/custom-motorcycle-rd', lot_4b_prospectus_link: 'https://warioware.example.com/investors/bomb-disposal-tech', lot_4c_prospectus_link: 'https://warioware.example.com/investors/nose-picking-innovations', lot_5_prospectus_link: 'https://warioware.example.com/investors/wah-crypto-holdings', managed_service_provider_name: 'WarioWare, Inc. Enterprise Solutions', managed_service_provider_telephone: '1-800-WAH-HAHA', managed_service_provider_email: 'gimmecoins@warioware.example.com' } }

      it 'does not create a change log' do
        expect { change_log }.not_to change(described_class, :count)
      end
    end

    context 'when the supplier only has some supplier attributes' do
      let(:supplier_contact_information_attributes) { { managed_service_provider_name: 'WarioWare, Inc. Enterprise Solutions', managed_service_provider_telephone: '1-800-WAH-HAHA', managed_service_provider_email: 'gimmecoins@warioware.example.com' } }

      context 'when all attributes are updated' do
        let(:supplier_contact_information_updates) { { managed_service_provider_name: 'Super Mario Bros. Managed Services', managed_service_provider_telephone: '1-800-ITS-A-MEE', managed_service_provider_email: 'mario.jumpman@mushroomkingdom.example.com' } }
        let(:expected_change_data) { { 'id' => supplier_contact_information.id, 'supplier_name' => 'Wario', 'before' => { 'additional_details' => { 'managed_service_provider_name' => 'WarioWare, Inc. Enterprise Solutions', 'managed_service_provider_telephone' => '1-800-WAH-HAHA', 'managed_service_provider_email' => 'gimmecoins@warioware.example.com' } }, 'after' => { 'additional_details' => { 'managed_service_provider_name' => 'Super Mario Bros. Managed Services', 'managed_service_provider_telephone' => '1-800-ITS-A-MEE', 'managed_service_provider_email' => 'mario.jumpman@mushroomkingdom.example.com' } } } }

        include_context 'when testing a change type'
      end

      context 'when some attributes are updated' do
        let(:supplier_contact_information_updates) { { managed_service_provider_name: 'Super Mario Bros. Managed Services', managed_service_provider_email: 'mario.jumpman@mushroomkingdom.example.com' } }
        let(:expected_change_data) { { 'id' => supplier_contact_information.id, 'supplier_name' => 'Wario', 'before' => { 'additional_details' => { 'managed_service_provider_name' => 'WarioWare, Inc. Enterprise Solutions', 'managed_service_provider_email' => 'gimmecoins@warioware.example.com' } }, 'after' => { 'additional_details' => { 'managed_service_provider_name' => 'Super Mario Bros. Managed Services', 'managed_service_provider_email' => 'mario.jumpman@mushroomkingdom.example.com' } } } }

        include_context 'when testing a change type'
      end

      context 'when all attributes are updated and some did not exist before' do
        let(:supplier_contact_information_attributes) { { additional_details: {} } }
        let(:supplier_contact_information_updates) { { managed_service_provider_name: 'Super Mario Bros. Managed Services', managed_service_provider_telephone: '1-800-ITS-A-MEE', managed_service_provider_email: 'mario.jumpman@mushroomkingdom.example.com' } }
        let(:expected_change_data) { { 'id' => supplier_contact_information.id, 'supplier_name' => 'Wario', 'before' => { 'additional_details' => {} }, 'after' => { 'additional_details' => { 'managed_service_provider_name' => 'Super Mario Bros. Managed Services', 'managed_service_provider_telephone' => '1-800-ITS-A-MEE', 'managed_service_provider_email' => 'mario.jumpman@mushroomkingdom.example.com' } } } }

        include_context 'when testing a change type'
      end

      context 'when no attributes are updated' do
        let(:supplier_contact_information_updates) { { managed_service_provider_name: 'WarioWare, Inc. Enterprise Solutions', managed_service_provider_telephone: '1-800-WAH-HAHA', managed_service_provider_email: 'gimmecoins@warioware.example.com' } }

        it 'does not create a change log' do
          expect { change_log }.not_to change(described_class, :count)
        end
      end
    end
  end

  describe '.log_update_supplier_framework_lot_status!' do
    let(:user) { create(:user) }
    let(:framework_id) { 'RM6360' }
    let(:supplier) { create(:supplier, name: 'Wario') }
    let(:supplier_framework) { create(:supplier_framework, framework_id:, supplier:) }
    let(:supplier_framework_lot) { create(:supplier_framework_lot, supplier_framework: supplier_framework, lot_id: 'RM6360.1', enabled: false) }
    let(:change_log) { described_class.log_update_supplier_framework_lot_status!(user: user, framework: framework_id, model: supplier_framework_lot) }
    let(:supplier_framework_lot_updates) { { enabled: true } }

    before do
      supplier_framework_lot.assign_attributes(supplier_framework_lot_updates)
      supplier_framework_lot.save!
    end

    it 'creates the change log' do
      expect { change_log }.to change(described_class, :count).by(1)
    end

    it 'has the right user' do
      expect(change_log.user).to eq(user)
    end

    it 'has the right framework' do
      expect(change_log.framework_id).to eq('RM6360')
    end

    it 'has the right change type' do
      expect(change_log.change_type).to eq('update_supplier_framework_lot_status')
    end

    it 'has the right change data' do
      expect(change_log.change_data).to eq({ 'id' => supplier_framework_lot.id, 'supplier_name' => 'Wario', 'lot_id' => 'RM6360.1', 'before' => { 'enabled' => false }, 'after' => { 'enabled' => true } })
    end

    context 'when no attributes are updated' do
      let(:supplier_framework_lot_updates) { { enabled: false } }

      it 'does not create a change log' do
        expect { change_log }.not_to change(described_class, :count)
      end
    end
  end

  describe '.log_update_supplier_framework_lot_services!' do
    let(:user) { create(:user) }
    let(:framework_id) { 'RM6360' }
    let(:supplier) { create(:supplier, name: 'Wario') }
    let(:supplier_framework) { create(:supplier_framework, framework_id:, supplier:) }
    let(:supplier_framework_lot) { create(:supplier_framework_lot, supplier_framework: supplier_framework, lot_id: 'RM6376.1') }
    let(:change_type) { 'update_supplier_framework_lot_services' }
    let(:change_log) { described_class.log_update_supplier_framework_lot_services!(user: user, framework: framework_id, model: supplier_framework_lot, added: supplier_framework_lot_services_added, removed: supplier_framework_lot_services_removed) }

    context 'when services are added and removed' do
      let(:supplier_framework_lot_services_added) { ['RM6360.1.1', 'RM6360.1.2', 'RM6360.1.3'] }
      let(:supplier_framework_lot_services_removed) { ['RM6360.1.4', 'RM6360.1.5', 'RM6360.1.6'] }
      let(:expected_change_data) { { 'id' => supplier_framework_lot.id, 'supplier_name' => 'Wario', 'lot_id' => 'RM6376.1', 'added' => ['RM6360.1.1', 'RM6360.1.2', 'RM6360.1.3'], 'removed' => ['RM6360.1.4', 'RM6360.1.5', 'RM6360.1.6'] } }

      include_context 'when testing a change type'
    end

    context 'when services are added and not removed' do
      let(:supplier_framework_lot_services_added) { ['RM6360.1.1', 'RM6360.1.2', 'RM6360.1.3'] }
      let(:supplier_framework_lot_services_removed) { [] }
      let(:expected_change_data) { { 'id' => supplier_framework_lot.id, 'supplier_name' => 'Wario', 'lot_id' => 'RM6376.1', 'added' => ['RM6360.1.1', 'RM6360.1.2', 'RM6360.1.3'], 'removed' => [] } }

      include_context 'when testing a change type'
    end

    context 'when services are removed and not added' do
      let(:supplier_framework_lot_services_added) { [] }
      let(:supplier_framework_lot_services_removed) { ['RM6360.1.4', 'RM6360.1.5', 'RM6360.1.6'] }
      let(:expected_change_data) { { 'id' => supplier_framework_lot.id, 'supplier_name' => 'Wario', 'lot_id' => 'RM6376.1', 'added' => [], 'removed' => ['RM6360.1.4', 'RM6360.1.5', 'RM6360.1.6'] } }

      include_context 'when testing a change type'
    end

    context 'when no services are added or removed' do
      let(:supplier_framework_lot_services_added) { [] }
      let(:supplier_framework_lot_services_removed) { [] }

      it 'does not create a change log' do
        expect { change_log }.not_to change(described_class, :count)
      end
    end
  end

  describe '.log_update_supplier_framework_lot_jurisdictions!' do
    let(:user) { create(:user) }
    let(:framework_id) { 'RM6360' }
    let(:supplier) { create(:supplier, name: 'Wario') }
    let(:supplier_framework) { create(:supplier_framework, framework_id:, supplier:) }
    let(:supplier_framework_lot) { create(:supplier_framework_lot, supplier_framework: supplier_framework, lot_id: 'RM6376.1') }
    let(:change_type) { 'update_supplier_framework_lot_jurisdictions' }
    let(:change_log) { described_class.log_update_supplier_framework_lot_jurisdictions!(user: user, framework: framework_id, model: supplier_framework_lot, added: supplier_framework_lot_jurisdictions_added, removed: supplier_framework_lot_jurisdictions_removed) }

    context 'when jurisdictions are added and removed' do
      let(:supplier_framework_lot_jurisdictions_added) { ['GB', 'AO', 'UY'] }
      let(:supplier_framework_lot_jurisdictions_removed) { ['PH', 'RO', 'KZ'] }
      let(:expected_change_data) { { 'id' => supplier_framework_lot.id, 'supplier_name' => 'Wario', 'lot_id' => 'RM6376.1', 'added' => ['GB', 'AO', 'UY'], 'removed' => ['PH', 'RO', 'KZ'] } }

      include_context 'when testing a change type'
    end

    context 'when jurisdictions are added and not removed' do
      let(:supplier_framework_lot_jurisdictions_added) { ['GB', 'AO', 'UY'] }
      let(:supplier_framework_lot_jurisdictions_removed) { [] }
      let(:expected_change_data) { { 'id' => supplier_framework_lot.id, 'supplier_name' => 'Wario', 'lot_id' => 'RM6376.1', 'added' => ['GB', 'AO', 'UY'], 'removed' => [] } }

      include_context 'when testing a change type'
    end

    context 'when jurisdictions are removed and not added' do
      let(:supplier_framework_lot_jurisdictions_added) { [] }
      let(:supplier_framework_lot_jurisdictions_removed) { ['PH', 'RO', 'KZ'] }
      let(:expected_change_data) { { 'id' => supplier_framework_lot.id, 'supplier_name' => 'Wario', 'lot_id' => 'RM6376.1', 'added' => [], 'removed' => ['PH', 'RO', 'KZ'] } }

      include_context 'when testing a change type'
    end

    context 'when no jurisdictions are added or removed' do
      let(:supplier_framework_lot_jurisdictions_added) { [] }
      let(:supplier_framework_lot_jurisdictions_removed) { [] }

      it 'does not create a change log' do
        expect { change_log }.not_to change(described_class, :count)
      end
    end
  end

  describe '.log_update_supplier_framework_lot_rates!' do
    let(:user) { create(:user) }
    let(:framework_id) { 'RM6360' }
    let(:supplier) { create(:supplier, name: 'Wario') }
    let(:supplier_framework) { create(:supplier_framework, framework_id:, supplier:) }
    let(:supplier_framework_lot) { create(:supplier_framework_lot, supplier_framework: supplier_framework, lot_id: 'RM6376.1') }
    let(:supplier_framework_lot_jurisdiction) { create(:supplier_framework_lot_jurisdiction, jurisdiction_id: 'GB') }
    let(:supplier_framework_lot_rate_1) { create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, jurisdiction: supplier_framework_lot_jurisdiction, rate: 15000, position_id: 'RM6376.1.1') }
    let(:supplier_framework_lot_rate_2) { create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, jurisdiction: supplier_framework_lot_jurisdiction, rate: 18000, position_id: 'RM6376.1.2') }
    let(:change_type) { 'update_supplier_framework_lot_rates' }
    let(:change_log) { described_class.log_update_supplier_framework_lot_rates!(user: user, framework: framework_id, model: supplier_framework_lot, rates: rates) }

    before do
      supplier_framework_lot_rate_1.reload
      supplier_framework_lot_rate_2.reload
    end

    context 'when rates were added' do
      let(:supplier_framework_lot_rate_3) { create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, jurisdiction: supplier_framework_lot_jurisdiction, rate: 20000, position_id: 'RM6376.1.3') }
      let(:rates) { { 'RM6376.1.1' => supplier_framework_lot_rate_1, 'RM6376.1.2' => supplier_framework_lot_rate_2, 'RM6376.1.3' => supplier_framework_lot_rate_3 } }
      let(:expected_change_data) { { 'id' => supplier_framework_lot.id, 'supplier_name' => 'Wario', 'lot_id' => 'RM6376.1', 'jurisdiction_id' => 'GB', 'rates' => [{ 'after' => 20000, 'id' => supplier_framework_lot_rate_3.id, 'position_id' => 'RM6376.1.3' }] } }

      include_context 'when testing a change type'
    end

    context 'when rates were added but instantly destroyed' do
      let(:supplier_framework_lot_rate_4) { build(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, jurisdiction: supplier_framework_lot_jurisdiction, rate: 20000, position_id: 'RM6376.1.4') }
      let(:rates) { { 'RM6376.1.1' => supplier_framework_lot_rate_1, 'RM6376.1.2' => supplier_framework_lot_rate_2, 'RM6376.1.4' => supplier_framework_lot_rate_4 } }
      let(:expected_change_data) { { 'id' => supplier_framework_lot.id, 'supplier_name' => 'Wario', 'lot_id' => 'RM6376.1', 'jurisdiction_id' => 'GB', 'rates' => [{ 'after' => 20000, 'id' => supplier_framework_lot_rate_3.id, 'position_id' => 'RM6376.1.3' }] } }

      it 'does not create a change log' do
        expect { change_log }.not_to change(described_class, :count)
      end
    end

    context 'when rates were removed' do
      let(:rates) { { 'RM6376.1.1' => supplier_framework_lot_rate_1, 'RM6376.1.2' => supplier_framework_lot_rate_2 } }
      let(:expected_change_data) { { 'id' => supplier_framework_lot.id, 'supplier_name' => 'Wario', 'lot_id' => 'RM6376.1', 'jurisdiction_id' => 'GB', 'rates' => [{ 'before' => 15000, 'id' => supplier_framework_lot_rate_1.id, 'position_id' => 'RM6376.1.1' }] } }

      before { supplier_framework_lot_rate_1.destroy }

      include_context 'when testing a change type'
    end

    context 'when rates were updated' do
      let(:rates) { { 'RM6376.1.1' => supplier_framework_lot_rate_1, 'RM6376.1.2' => supplier_framework_lot_rate_2 } }
      let(:expected_change_data) { { 'id' => supplier_framework_lot.id, 'supplier_name' => 'Wario', 'lot_id' => 'RM6376.1', 'jurisdiction_id' => 'GB', 'rates' => [{ 'before' => 18000, 'after' => 17999, 'id' => supplier_framework_lot_rate_2.id, 'position_id' => 'RM6376.1.2' }] } }

      before do
        supplier_framework_lot_rate_2.assign_attributes(rate: 17999)
        supplier_framework_lot_rate_2.save
      end

      include_context 'when testing a change type'
    end

    context 'when rates are added, deleted and updated' do
      let(:supplier_framework_lot_rate_3) { create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, jurisdiction: supplier_framework_lot_jurisdiction, rate: 20000, position_id: 'RM6376.1.3') }
      let(:supplier_framework_lot_rate_4) { build(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, jurisdiction: supplier_framework_lot_jurisdiction, rate: 20000, position_id: 'RM6376.1.4') }
      let(:rates) { { 'RM6376.1.1' => supplier_framework_lot_rate_1, 'RM6376.1.2' => supplier_framework_lot_rate_2, 'RM6376.1.3' => supplier_framework_lot_rate_3, 'RM6376.1.4' => supplier_framework_lot_rate_4 } }
      let(:expected_change_data) { { 'id' => supplier_framework_lot.id, 'supplier_name' => 'Wario', 'lot_id' => 'RM6376.1', 'jurisdiction_id' => 'GB', 'rates' => [{ 'before' => 15000, 'id' => supplier_framework_lot_rate_1.id, 'position_id' => 'RM6376.1.1' }, { 'before' => 18000, 'after' => 17999, 'id' => supplier_framework_lot_rate_2.id, 'position_id' => 'RM6376.1.2' }, { 'after' => 20000, 'id' => supplier_framework_lot_rate_3.id, 'position_id' => 'RM6376.1.3' }] } }

      before do
        supplier_framework_lot_rate_1.destroy
        supplier_framework_lot_rate_2.assign_attributes(rate: 17999)
        supplier_framework_lot_rate_2.save
      end

      include_context 'when testing a change type'
    end

    context 'when not rates are added, deleted or updated' do
      let(:rates) { { 'RM6376.1.1' => supplier_framework_lot_rate_1, 'RM6376.1.2' => supplier_framework_lot_rate_2 } }

      it 'does not create a change log' do
        expect { change_log }.not_to change(described_class, :count)
      end
    end
  end

  describe '.log_update_supplier_framework_lot_branch!' do
    let(:user) { create(:user) }
    let(:framework_id) { 'RM6376' }
    let(:supplier) { create(:supplier, name: 'Wario') }
    let(:supplier_framework) { create(:supplier_framework, framework_id:, supplier:) }
    let(:supplier_framework_lot) { create(:supplier_framework_lot, supplier_framework: supplier_framework, lot_id: 'RM6376.1') }
    let(:supplier_branch) { create(:supplier_framework_lot_branch, supplier_framework_lot:, **supplier_branch_attributes) }
    let(:supplier_branch_attributes) { { name: 'WarioWare, Inc.', region: 'Diamond City Zone', contact_name: 'Wario (CEO)', contact_email: 'gimmecoins@warioware.example.com', telephone_number: '1-800-WAH-HAHA', address_line_1: 'WarioWare Tower', address_line_2: 'Garlic District', town: 'Diamond City', county: 'Greater Game Grid', postcode: 'L4 0TH' } }
    let(:change_type) { 'update_supplier_framework_lot_branch' }
    let(:change_log) { described_class.log_update_supplier_framework_lot_branch!(user: user, framework: framework_id, model: supplier_branch) }

    before do
      [
        'L4 0TH',
        'B2 4BJ',
      ].compact.each do |postcode|
        Geocoder::Lookup::Test.add_stub(
          postcode, [{ 'coordinates' => [51.5201, -0.0759] }],
        )
      end

      supplier_branch.assign_attributes(supplier_branch_updates)
      supplier_branch.save!
    end

    after do
      Geocoder::Lookup::Test.reset
    end

    context 'when all attributes are updated' do
      let(:supplier_branch_updates) { { name: 'Mario Bros. Plumbing', region: 'Mushroom Kingdom Central', contact_name: 'Mario Jumpman', contact_email: 'mario.jumpman@mushroomkingdom.example.com', telephone_number: '1-800-ITS-A-MEE', address_line_1: '123 Mushroom Way', address_line_2: 'Pipe District 4', town: 'Toad Town', county: 'Mushroom County', postcode: 'B2 4BJ' } }
      let(:expected_change_data) { { 'id' => supplier_branch.id, 'supplier_name' => 'Wario', 'lot_id' => 'RM6376.1', 'before' => { 'name' => 'WarioWare, Inc.', 'region' => 'Diamond City Zone', 'contact_name' => 'Wario (CEO)', 'contact_email' => 'gimmecoins@warioware.example.com', 'telephone_number' => '1-800-WAH-HAHA', 'address_line_1' => 'WarioWare Tower', 'address_line_2' => 'Garlic District', 'town' => 'Diamond City', 'county' => 'Greater Game Grid', 'postcode' => 'L4 0TH' }, 'after' => { 'name' => 'Mario Bros. Plumbing', 'region' => 'Mushroom Kingdom Central', 'contact_name' => 'Mario Jumpman', 'contact_email' => 'mario.jumpman@mushroomkingdom.example.com', 'telephone_number' => '1-800-ITS-A-MEE', 'address_line_1' => '123 Mushroom Way', 'address_line_2' => 'Pipe District 4', 'town' => 'Toad Town', 'county' => 'Mushroom County', 'postcode' => 'B2 4BJ' } } }

      include_context 'when testing a change type'
    end

    context 'when some attributes are updated' do
      let(:supplier_branch_updates) { { name: 'Mario Bros. Plumbing', contact_name: 'Mario Jumpman', telephone_number: '1-800-ITS-A-MEE', address_line_2: 'Pipe District 4', county: 'Mushroom County' } }
      let(:expected_change_data) { { 'id' => supplier_branch.id, 'supplier_name' => 'Wario', 'lot_id' => 'RM6376.1', 'before' => { 'name' => 'WarioWare, Inc.', 'contact_name' => 'Wario (CEO)', 'telephone_number' => '1-800-WAH-HAHA', 'address_line_2' => 'Garlic District', 'county' => 'Greater Game Grid' }, 'after' => { 'name' => 'Mario Bros. Plumbing', 'contact_name' => 'Mario Jumpman', 'telephone_number' => '1-800-ITS-A-MEE', 'address_line_2' => 'Pipe District 4', 'county' => 'Mushroom County' } } }

      include_context 'when testing a change type'
    end

    context 'when all attributes are updated and some did not exist before' do
      let(:supplier_branch_attributes) { { name: 'WarioWare, Inc.', region: 'Diamond City Zone', contact_name: 'Wario (CEO)', contact_email: 'gimmecoins@warioware.example.com', telephone_number: '1-800-WAH-HAHA', address_line_1: 'WarioWare Tower', town: 'Diamond City', postcode: 'L4 0TH' } }
      let(:supplier_branch_updates) { { name: 'Mario Bros. Plumbing', region: 'Mushroom Kingdom Central', contact_name: 'Mario Jumpman', contact_email: 'mario.jumpman@mushroomkingdom.example.com', telephone_number: '1-800-ITS-A-MEE', address_line_1: '123 Mushroom Way', address_line_2: 'Pipe District 4', town: 'Toad Town', county: 'Mushroom County', postcode: 'B2 4BJ' } }
      let(:expected_change_data) { { 'id' => supplier_branch.id, 'supplier_name' => 'Wario', 'lot_id' => 'RM6376.1', 'before' => { 'name' => 'WarioWare, Inc.', 'region' => 'Diamond City Zone', 'contact_name' => 'Wario (CEO)', 'contact_email' => 'gimmecoins@warioware.example.com', 'telephone_number' => '1-800-WAH-HAHA', 'address_line_1' => 'WarioWare Tower', 'address_line_2' => nil, 'town' => 'Diamond City', 'county' => nil, 'postcode' => 'L4 0TH' }, 'after' => { 'name' => 'Mario Bros. Plumbing', 'region' => 'Mushroom Kingdom Central', 'contact_name' => 'Mario Jumpman', 'contact_email' => 'mario.jumpman@mushroomkingdom.example.com', 'telephone_number' => '1-800-ITS-A-MEE', 'address_line_1' => '123 Mushroom Way', 'address_line_2' => 'Pipe District 4', 'town' => 'Toad Town', 'county' => 'Mushroom County', 'postcode' => 'B2 4BJ' } } }

      include_context 'when testing a change type'
    end

    context 'when no attributes are updated' do
      let(:supplier_branch_updates) { { name: 'WarioWare, Inc.', region: 'Diamond City Zone', contact_name: 'Wario (CEO)', contact_email: 'gimmecoins@warioware.example.com', telephone_number: '1-800-WAH-HAHA', address_line_1: 'WarioWare Tower', address_line_2: 'Garlic District', town: 'Diamond City', county: 'Greater Game Grid', postcode: 'L4 0TH' } }

      it 'does not create a change log' do
        expect { change_log }.not_to change(described_class, :count)
      end
    end
  end

  describe '.log_add_rates_for_supplier_framework_lot_jurisdiction!' do
    let(:user) { create(:user) }
    let(:framework_id) { 'RM6360' }
    let(:supplier) { create(:supplier, name: 'Wario') }
    let(:supplier_framework) { create(:supplier_framework, framework_id:, supplier:) }
    let(:supplier_framework_lot) { create(:supplier_framework_lot, supplier_framework: supplier_framework, lot_id: 'RM6376.1') }
    let(:supplier_framework_lot_jurisdiction) { create(:supplier_framework_lot_jurisdiction, jurisdiction_id: 'GB') }
    let(:supplier_framework_lot_rate_1) { build(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, jurisdiction: supplier_framework_lot_jurisdiction, rate: 15000, position_id: 'RM6376.1.1') }
    let(:supplier_framework_lot_rate_2) { build(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, jurisdiction: supplier_framework_lot_jurisdiction, rate: nil, position_id: 'RM6376.1.2') }
    let(:supplier_framework_lot_rate_3) { build(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, jurisdiction: supplier_framework_lot_jurisdiction, rate: 18000, position_id: 'RM6376.1.3') }
    let(:change_type) { 'add_rates_for_supplier_framework_lot_jurisdiction' }
    let(:change_log) { described_class.log_add_rates_for_supplier_framework_lot_jurisdiction!(user: user, framework: framework_id, model: supplier_framework_lot, rates: rates) }

    let(:rates) { { 'RM6376.1.1' => supplier_framework_lot_rate_1, 'RM6376.1.2' => supplier_framework_lot_rate_2, 'RM6376.1.3' => supplier_framework_lot_rate_3 } }
    let(:expected_change_data) { { 'id' => supplier_framework_lot.id, 'supplier_name' => 'Wario', 'lot_id' => 'RM6376.1', 'jurisdiction_id' => 'GB', 'rates' => [{ 'after' => 15000, 'id' => supplier_framework_lot_rate_1.id, 'position_id' => 'RM6376.1.1' }, { 'after' => 18000, 'id' => supplier_framework_lot_rate_3.id, 'position_id' => 'RM6376.1.3' }] } }

    before do
      rates.each_value do |supplier_framework_lot_rate|
        next if supplier_framework_lot_rate.rate.nil?

        supplier_framework_lot_rate.save!
      end
    end

    include_context 'when testing a change type'
  end

  describe '.log_remove_rates_for_supplier_framework_lot_jurisdiction!' do
    let(:user) { create(:user) }
    let(:framework_id) { 'RM6360' }
    let(:supplier) { create(:supplier, name: 'Wario') }
    let(:supplier_framework) { create(:supplier_framework, framework_id:, supplier:) }
    let(:supplier_framework_lot) { create(:supplier_framework_lot, supplier_framework: supplier_framework, lot_id: 'RM6376.1') }
    let(:supplier_framework_lot_jurisdiction) { create(:supplier_framework_lot_jurisdiction, jurisdiction_id: 'GB') }
    let(:supplier_framework_lot_rate_1) { create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, jurisdiction: supplier_framework_lot_jurisdiction, rate: 15000, position_id: 'RM6376.1.1') }
    let(:supplier_framework_lot_rate_2) { create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, jurisdiction: supplier_framework_lot_jurisdiction, rate: 16000, position_id: 'RM6376.1.2') }
    let(:supplier_framework_lot_rate_3) { create(:supplier_framework_lot_rate, supplier_framework_lot: supplier_framework_lot, jurisdiction: supplier_framework_lot_jurisdiction, rate: 18000, position_id: 'RM6376.1.3') }
    let(:change_type) { 'remove_rates_for_supplier_framework_lot_jurisdiction' }
    let(:change_log) { described_class.log_remove_rates_for_supplier_framework_lot_jurisdiction!(user: user, framework: framework_id, model: supplier_framework_lot, rates: rates) }
    let!(:rates) { { 'RM6376.1.1' => supplier_framework_lot_rate_1, 'RM6376.1.2' => supplier_framework_lot_rate_2, 'RM6376.1.3' => supplier_framework_lot_rate_3 } }
    let(:expected_change_data) { { 'id' => supplier_framework_lot.id, 'supplier_name' => 'Wario', 'lot_id' => 'RM6376.1', 'jurisdiction_id' => 'GB', 'rates' => [{ 'before' => 15000, 'id' => supplier_framework_lot_rate_1.id, 'position_id' => 'RM6376.1.1' }, { 'before' => 16000, 'id' => supplier_framework_lot_rate_2.id, 'position_id' => 'RM6376.1.2' }, { 'before' => 18000, 'id' => supplier_framework_lot_rate_3.id, 'position_id' => 'RM6376.1.3' }] } }

    before { supplier_framework_lot_jurisdiction.destroy! }

    include_context 'when testing a change type'
  end
end
