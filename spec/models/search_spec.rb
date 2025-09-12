require 'rails_helper'

RSpec.describe Search do
  describe 'associations' do
    let(:search) { create(:search) }

    it { is_expected.to belong_to(:framework) }
    it { is_expected.to belong_to(:user) }

    it 'has the framework relationship' do
      expect(search.framework).to be_present
    end

    it 'has the user relationship' do
      expect(search.user).to be_present
    end
  end

  describe '.serialised attributes' do
    let(:search) { create(:search) }

    it 'returns the search_criteria' do
      expect(search.search_criteria).to eq({ criteria: true })
    end

    it 'returns the search_result' do
      expect(search.search_result).to eq([['MABEL', '1'], ['CHARLES', '2'], ['OLIVER', '3']])
    end
  end

  describe '.log_new_search' do
    let(:result) { described_class.log_new_search(framework, user, session_id, search_criteria, search_result) }
    let(:search) { described_class.first }

    let(:user) { create(:user) }
    let(:framework) { create(:framework) }
    let(:session_id) { SecureRandom.uuid }
    let(:search_criteria) { { criteria_1: true, criteria_2: false, criteria_3: 'Elma' } }
    let(:suppliers) { [create(:supplier, name: 'Supplier A'), create(:supplier, name: 'Supplier B')] }
    let(:search_result) { suppliers.map { |supplier| create(:supplier_framework, supplier:, framework:) } }

    context 'when the search does not exist' do
      it 'has a truthy result' do
        expect(result).to be_truthy
      end

      it 'creates the record' do
        expect { result }.to change(described_class, :count).by(1)
      end

      it 'has the correct attributes for the search' do
        result

        expect(search.attributes.except('id', 'created_at', 'updated_at')).to eq(
          {
            'framework_id' => framework.id,
            'search_criteria' => { criteria_1: true, criteria_2: false, criteria_3: 'Elma' },
            'search_result' => [['Supplier A', suppliers[0].id], ['Supplier B', suppliers[1].id]],
            'session_id' => session_id,
            'user_id' => user.id,
          }
        )
      end
    end

    context 'when a search does exist' do
      let(:search) { described_class.where.not(id: existing_search.id).first }
      let(:existing_search) do
        described_class.create(
          framework_id: framework.id,
          user_id: user.id,
          session_id: session_id,
          search_criteria: search_criteria,
          search_result: search_result.map { |supplier_framework| [supplier_framework.supplier.name, supplier_framework.supplier.id] }
        )
      end

      before { existing_search }

      it 'has a falsey result' do
        expect(result).to be_falsey
      end

      it 'deso not change the count' do
        expect { result }.not_to change(described_class, :count)
      end

      context 'and it is a different user' do
        let(:result) { described_class.log_new_search(framework, new_user, session_id, search_criteria, search_result) }
        let(:new_user) { create(:user) }

        it 'has a truthy result' do
          expect(result).to be_truthy
        end

        it 'creates the record' do
          expect { result }.to change(described_class, :count).by(1)
        end

        it 'has the correct attributes for the search' do
          result

          expect(search.attributes.except('id', 'created_at', 'updated_at')).to eq(
            {
              'framework_id' => framework.id,
              'search_criteria' => { criteria_1: true, criteria_2: false, criteria_3: 'Elma' },
              'search_result' => [['Supplier A', suppliers[0].id], ['Supplier B', suppliers[1].id]],
              'session_id' => session_id,
              'user_id' => new_user.id,
            }
          )
        end
      end

      context 'and it is a different frameworks' do
        let(:result) { described_class.log_new_search(new_framework, user, session_id, search_criteria, search_result) }
        let(:new_framework) { create(:framework) }

        it 'has a truthy result' do
          expect(result).to be_truthy
        end

        it 'creates the record' do
          expect { result }.to change(described_class, :count).by(1)
        end

        it 'has the correct attributes for the search' do
          result

          expect(search.attributes.except('id', 'created_at', 'updated_at')).to eq(
            {
              'framework_id' => new_framework.id,
              'search_criteria' => { criteria_1: true, criteria_2: false, criteria_3: 'Elma' },
              'search_result' => [['Supplier A', suppliers[0].id], ['Supplier B', suppliers[1].id]],
              'session_id' => session_id,
              'user_id' => user.id,
            }
          )
        end
      end

      context 'and it is a different session_id' do
        let(:result) { described_class.log_new_search(framework, user, new_session_id, search_criteria, search_result) }
        let(:new_session_id) { SecureRandom.uuid }

        it 'has a truthy result' do
          expect(result).to be_truthy
        end

        it 'creates the record' do
          expect { result }.to change(described_class, :count).by(1)
        end

        it 'has the correct attributes for the search' do
          result

          expect(search.attributes.except('id', 'created_at', 'updated_at')).to eq(
            {
              'framework_id' => framework.id,
              'search_criteria' => { criteria_1: true, criteria_2: false, criteria_3: 'Elma' },
              'search_result' => [['Supplier A', suppliers[0].id], ['Supplier B', suppliers[1].id]],
              'session_id' => new_session_id,
              'user_id' => user.id,
            }
          )
        end
      end

      context 'and it is a different search_criteria' do
        let(:result) { described_class.log_new_search(framework, user, session_id, new_search_criteria, search_result) }
        let(:new_search_criteria) { { criteria_1: false, criteria_2: false, criteria_3: 'Elma' } }

        it 'has a truthy result' do
          expect(result).to be_truthy
        end

        it 'creates the record' do
          expect { result }.to change(described_class, :count).by(1)
        end

        it 'has the correct attributes for the search' do
          result

          expect(search.attributes.except('id', 'created_at', 'updated_at')).to eq(
            {
              'framework_id' => framework.id,
              'search_criteria' => { criteria_1: false, criteria_2: false, criteria_3: 'Elma' },
              'search_result' => [['Supplier A', suppliers[0].id], ['Supplier B', suppliers[1].id]],
              'session_id' => session_id,
              'user_id' => user.id,
            }
          )
        end
      end

      context 'and it is a different search_result' do
        let(:result) { described_class.log_new_search(framework, user, session_id, search_criteria, new_search_result) }
        let(:new_search_result) { [create(:supplier, name: 'Supplier C'), create(:supplier, name: 'Supplier D')].map { |supplier| create(:supplier_framework, supplier:, framework:) } }

        it 'has a falsey result' do
          expect(result).to be_falsey
        end

        it 'deso not change the count' do
          expect { result }.not_to change(described_class, :count)
        end
      end
    end
  end
end
