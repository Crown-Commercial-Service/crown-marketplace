require 'rails_helper'

RSpec.describe UploadsController, type: :controller do
  describe 'POST create' do
    let(:unique_supplier_name) { "Acme Teachers Ltd #{Time.current}" }
    let(:unique_supplier_id) { SecureRandom.uuid }
    let(:unique_postcode) { rand(36**8).to_s(36) }

    let(:branches) do
      [
        {
          postcode: unique_postcode
        }
      ]
    end

    let(:suppliers) do
      [
        {
          supplier_name: unique_supplier_name,
          supplier_id: unique_supplier_id,
          branches: branches
        }
      ]
    end

    let(:valid_postcode) { instance_double(UKPostcode::GeographicPostcode, valid?: true) }

    before do
      allow(UKPostcode).to receive(:parse).and_return(valid_postcode)
    end

    context 'when JSON is invalid' do
      it 'raises error' do
        expect do
          post :create, body: '{'
        end.to raise_error(JSON::ParserError)
      end
    end

    context 'when supplier list is empty' do
      let(:suppliers) { [] }

      it 'does not create any suppliers' do
        expect do
          post :create, body: suppliers.to_json
        end.not_to change(Supplier, :count)
      end
    end

    context 'when supplier does not exist' do
      it 'creates supplier' do
        expect do
          post :create, body: suppliers.to_json
        end.to change(Supplier, :count).by(1)
      end

      it 'assigns ID to supplier' do
        post :create, body: suppliers.to_json

        supplier = Supplier.last
        expect(supplier.id).to eq(unique_supplier_id)
      end

      it 'assigns name to supplier' do
        post :create, body: suppliers.to_json

        supplier = Supplier.last
        expect(supplier.name).to eq(unique_supplier_name)
      end

      it 'creates a branch associated with supplier' do
        expect do
          post :create, body: suppliers.to_json
        end.to change(Branch, :count).by(1)
      end

      it 'assigns attributes to the branch' do
        post :create, body: suppliers.to_json

        supplier = Supplier.last
        branch = supplier.branches.first
        expect(branch.postcode).to eq(unique_postcode)
      end

      context 'and supplier has multiple branches' do
        let(:another_unique_postcode) { rand(36**8).to_s(36) }
        let(:branches) do
          [
            {
              postcode: unique_postcode
            },
            {
              postcode: another_unique_postcode
            }
          ]
        end

        it 'creates two branches associated with supplier' do
          expect do
            post :create, body: suppliers.to_json
          end.to change(Branch, :count).by(2)
        end

        it 'assigns attributes to the branches' do
          post :create, body: suppliers.to_json

          supplier = Supplier.last
          branches = supplier.branches
          expect(branches.map(&:postcode)).to include(unique_postcode, another_unique_postcode)
        end
      end
    end

    context 'when supplier does exist' do
      before do
        Supplier.create!(id: unique_supplier_id, name: unique_supplier_name)
      end

      it 'does not create supplier' do
        expect do
          post :create, body: suppliers.to_json
        end.not_to change(Supplier, :count)
      end

      it 'reports an error in the response' do
        post :create, body: suppliers.to_json

        result = JSON.parse(response.body)
        expect(result['errors']).to include(unique_supplier_id)
      end
    end

    context 'when data for one supplier is invalid' do
      let(:suppliers) do
        [
          {
            supplier_name: unique_supplier_name,
            branches: []
          },
          {
            supplier_name: '',
            branches: []
          }
        ]
      end

      it 'raises ActiveRecord::RecordInvalid exception' do
        expect do
          post :create, body: suppliers.to_json
        end.to raise_error(ActiveRecord::RecordInvalid)
      end

      it 'does not create any suppliers' do
        expect do
          ignoring_exception(ActiveRecord::RecordInvalid) do
            post :create, body: suppliers.to_json
          end
        end.not_to change(Supplier, :count)
      end
    end
  end

  private

  def ignoring_exception(klass)
    yield
  rescue klass
    nil
  end
end
