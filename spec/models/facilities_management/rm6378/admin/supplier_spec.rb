require 'rails_helper'

RSpec.describe FacilitiesManagement::RM6378::Admin::Supplier do
  let(:supplier) { create(:facilities_management_rm6378_admin_supplier) }
  let(:existing_supplier) { create(:facilities_management_rm6378_admin_supplier) }

  # rubocop:disable RSpec/NestedGroups
  describe 'validations' do
    before { supplier.assign_attributes(attributes) }

    context 'when validating basic_supplier_information' do
      let(:attributes) { { name:, duns_number:, sme: } }

      let(:name) { Faker::Name.unique.name }
      let(:duns_number) { Faker::Company.unique.duns_number.gsub('-', '') }
      let(:sme) { true }

      context 'when considering the name' do
        context 'and it is nil' do
          let(:name) { nil }

          it 'is invalid and has the correct error message' do
            expect(supplier.valid?(:basic_supplier_information)).to be(false)
            expect(supplier.errors[:name].first).to eq('The supplier name cannot be blank')
          end
        end

        context 'and it is blank' do
          let(:name) { '' }

          it 'is invalid and has the correct error message' do
            expect(supplier.valid?(:basic_supplier_information)).to be(false)
            expect(supplier.errors[:name].first).to eq('The supplier name cannot be blank')
          end
        end

        context 'and it is too long' do
          let(:name) { 'a' * 256 }

          it 'is invalid and has the correct error message' do
            expect(supplier.valid?(:basic_supplier_information)).to be(false)
            expect(supplier.errors[:name].first).to eq('The supplier name must be no more than 255 characters')
          end
        end

        context 'and it is taken' do
          let(:name) { existing_supplier.name }

          it 'is invalid and has the correct error message' do
            expect(supplier.valid?(:basic_supplier_information)).to be(false)
            expect(supplier.errors[:name].first).to eq('The supplier name you entered is already in use by another supplier')
          end
        end

        context 'and it is present' do
          context 'and it has excess white space' do
            let(:name) { '     I am the name     ' }

            it 'is valid and removes the excess white space' do
              expect(supplier).to be_valid(:basic_supplier_information)
              expect(supplier.name).to eq('I am the name')
            end
          end

          it 'is valid' do
            expect(supplier).to be_valid(:basic_supplier_information)
          end
        end
      end

      context 'when considering the duns number' do
        context 'and it is nil' do
          let(:duns_number) { nil }

          it 'is invalid and has the correct error message' do
            expect(supplier.valid?(:basic_supplier_information)).to be(false)
            expect(supplier.errors[:duns_number].first).to eq('The DUNS number cannot be blank')
          end
        end

        context 'and it is blank' do
          let(:duns_number) { '' }

          it 'is invalid and has the correct error message' do
            expect(supplier.valid?(:basic_supplier_information)).to be(false)
            expect(supplier.errors[:duns_number].first).to eq('The DUNS number cannot be blank')
          end
        end

        context 'and it is too short' do
          let(:duns_number) { '1' * 7 }

          it 'is invalid and has the correct error message' do
            expect(supplier.valid?(:basic_supplier_information)).to be(false)
            expect(supplier.errors[:duns_number].first).to eq('The DUNS number must be 9 digits')
          end
        end

        context 'and it is too long' do
          let(:duns_number) { '1' * 12 }

          it 'is invalid and has the correct error message' do
            expect(supplier.valid?(:basic_supplier_information)).to be(false)
            expect(supplier.errors[:duns_number].first).to eq('The DUNS number must be 9 digits')
          end
        end

        context 'and it is not number' do
          let(:duns_number) { 'notnumber' }

          it 'is invalid and has the correct error message' do
            expect(supplier.valid?(:basic_supplier_information)).to be(false)
            expect(supplier.errors[:duns_number].first).to eq('The DUNS number must be 9 digits')
          end
        end

        context 'and it is taken' do
          let(:duns_number) { existing_supplier.duns_number }

          it 'is invalid and has the correct error message' do
            expect(supplier.valid?(:basic_supplier_information)).to be(false)
            expect(supplier.errors[:duns_number].first).to eq('The DUNS number you entered is already in use by another supplier')
          end
        end

        context 'and it is present' do
          context 'and it has excess white space' do
            let(:duns_number) { '     123456789     ' }

            it 'is valid and removes the excess white space' do
              expect(supplier).to be_valid(:basic_supplier_information)
              expect(supplier.duns_number).to eq('123456789')
            end
          end

          it 'is valid' do
            expect(supplier).to be_valid(:basic_supplier_information)
          end
        end
      end

      context 'when considering the sme status' do
        context 'and it is nil' do
          let(:sme) { nil }

          it 'is invalid and has the correct error message' do
            expect(supplier.valid?(:basic_supplier_information)).to be(false)
            expect(supplier.errors[:sme].first).to eq('Select if the supplier is an SME')
          end
        end

        context 'and it is blank' do
          let(:sme) { '' }

          it 'is invalid and has the correct error message' do
            expect(supplier.valid?(:basic_supplier_information)).to be(false)
            expect(supplier.errors[:sme].first).to eq('Select if the supplier is an SME')
          end
        end

        context 'and it is true' do
          it 'is valid' do
            expect(supplier).to be_valid(:basic_supplier_information)
          end
        end

        context 'and it is false' do
          let(:sme) { false }

          it 'is valid' do
            expect(supplier).to be_valid(:basic_supplier_information)
          end
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
