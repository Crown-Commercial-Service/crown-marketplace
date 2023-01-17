require 'rails_helper'

# rubocop:disable RSpec/NestedGroups
RSpec.describe Cognito::Admin::User do
  let(:cognito_admin_user) { described_class.new(current_user_access, attributes) }

  let(:current_user_access) { :super_admin }
  let(:cognito_uuid) { SecureRandom.uuid }
  let(:email) { 'user@crowncommercial.gov.uk' }
  let(:email_verified) { true }
  let(:account_status) { true }
  let(:roles) { %w[buyer] }
  let(:telephone_number) { '07123456789' }
  let(:service_access) { %w[fm_access] }
  let(:mfa_enabled) { false }

  let(:attributes) do
    {
      cognito_uuid: cognito_uuid,
      email: email,
      email_verified: email_verified,
      telephone_number: telephone_number,
      roles: roles,
      service_access: service_access,
      account_status: account_status,
      confirmation_status: 'CONFIRMED',
      mfa_enabled: mfa_enabled
    }
  end

  describe '#validations on select_role' do
    let(:attributes) do
      {
        roles: roles,
      }
    end

    context 'when no role is selected' do
      let(:roles) { [] }

      it 'is invalid and it has the correct error message' do
        expect(cognito_admin_user).not_to be_valid(:select_role)
        expect(cognito_admin_user.errors[:roles].first).to eq 'Select one role for the user'
      end
    end

    context 'when multiple roles are selected' do
      let(:roles) { %w[buyer ccs_employee] }

      it 'is invalid and it has the correct error message' do
        expect(cognito_admin_user).not_to be_valid(:select_role)
        expect(cognito_admin_user.errors[:roles].first).to eq 'Select one role for the user'
      end
    end

    context 'and the roles are not within the users scope' do
      let(:roles) { %w[ccs_employee] }
      let(:current_user_access) { :user_support }

      it 'is invalid and it has the correct error message' do
        expect(cognito_admin_user).not_to be_valid(:select_role)
        expect(cognito_admin_user.errors[:roles].first).to eq 'You do not have the ability to create users with these roles'
      end
    end

    context 'when one role is selected' do
      let(:roles) { %w[allow_list_access] }

      it 'is valid' do
        expect(cognito_admin_user).to be_valid(:select_role)
      end
    end
  end

  describe '#validations on select_service_access' do
    let(:attributes) do
      {
        roles: roles,
        service_access: service_access
      }
    end
    let(:roles) { %w[buyer] }
    let(:service_access) { %w[fm_access] }

    context 'and the service_access is empty when it required' do
      let(:roles) { %w[ccs_employee] }
      let(:service_access) { [] }

      it 'is invalid and it has the correct error message' do
        expect(cognito_admin_user).not_to be_valid(:select_service_access)
        expect(cognito_admin_user.errors[:service_access].first).to eq 'You must select the service access for the user from this list'
      end
    end

    context 'and the service_access are not within the list' do
      let(:service_access) { %w[fake_service] }

      it 'is invalid and it has the correct error message' do
        expect(cognito_admin_user).not_to be_valid(:select_service_access)
        expect(cognito_admin_user.errors[:service_access].first).to eq 'You must select the service access for the user from this list'
      end
    end

    context 'when one service access is selected' do
      it 'is valid' do
        expect(cognito_admin_user).to be_valid(:select_service_access)
      end
    end
  end

  describe '#validations on enter_user_details' do
    let(:attributes) do
      {
        email: email,
        telephone_number: telephone_number,
        roles: roles,
        service_access: service_access
      }
    end
    let(:allow_list_file) { Tempfile.new('allow_list.txt') }
    let(:email_list) { ['email.com'] }
    let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }
    let(:users) { [] }

    before do
      allow_list_file.write(email_list.join("\n"))
      allow_list_file.close
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(AllowedEmailDomain).to receive(:allow_list_file_path).and_return(allow_list_file.path)
      # rubocop:enable RSpec/AnyInstance
      allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
      allow(aws_client).to receive(:list_users).and_return(OpenStruct.new(users: users))
    end

    after do
      allow_list_file.unlink
    end

    context 'when validating the email' do
      context 'and the email is nil' do
        let(:email) { '' }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:enter_user_details)
          expect(cognito_admin_user.errors[:email].first).to eq 'Enter an email address in the correct format, like name@example.com'
        end
      end

      context 'and the email contains an uppercase character' do
        let(:email) { 'uSer@cheemail.com' }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:enter_user_details)
          expect(cognito_admin_user.errors[:email].first).to eq 'Email address cannot contain any capital letters'
        end
      end

      context 'when the email is not on the allow list' do
        context 'and the current user is super_admin' do
          it 'is valid' do
            expect(cognito_admin_user).to be_valid(:enter_user_details)
          end
        end

        context 'and the current user is user_admin' do
          let(:current_user_access) { :user_admin }

          it 'is valid' do
            expect(cognito_admin_user).to be_valid(:enter_user_details)
          end
        end

        context 'and the current user is user_support' do
          let(:current_user_access) { :user_support }

          it 'is invalid and it has the correct error message' do
            expect(cognito_admin_user).not_to be_valid(:enter_user_details)
            expect(cognito_admin_user.errors[:email].first).to eq 'Email domain is not in the allow list'
          end
        end
      end

      context 'when the user already exists' do
        let(:users) { ['I am an existing user'] }
        let(:email) { 'user@email.com' }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:enter_user_details)
          expect(cognito_admin_user.errors[:email].first).to eq 'An account with this email already exists'
        end
      end

      context 'when there is a cognito error' do
        let(:email) { 'user@email.com' }

        before { allow(aws_client).to receive(:list_users).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('Some context', 'Some message')) }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:enter_user_details)
          expect(cognito_admin_user.errors[:base].first).to eq 'Some message'
        end
      end
    end

    context 'when validating the telephone number' do
      context 'when the phone number is too short' do
        let(:telephone_number) { '0712345678' }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:enter_user_details)
          expect(cognito_admin_user.errors[:telephone_number].first).to eq 'Enter a UK mobile telephone number, for example 07700900982'
        end
      end

      context 'when the phone number is too long' do
        let(:telephone_number) { '071234567891' }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:enter_user_details)
          expect(cognito_admin_user.errors[:telephone_number].first).to eq 'Enter a UK mobile telephone number, for example 07700900982'
        end
      end

      context 'when the phone number does not start with 07' do
        let(:telephone_number) { '12345678912' }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:enter_user_details)
          expect(cognito_admin_user.errors[:telephone_number].first).to eq 'Enter a UK mobile telephone number, for example 07700900982'
        end
      end

      context 'when the role requires the telephone number and it is blank' do
        let(:telephone_number) { '' }
        let(:roles) { %w[allow_list_access] }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:enter_user_details)
          expect(cognito_admin_user.errors[:telephone_number].first).to eq 'Enter a UK mobile telephone number, for example 07700900982'
        end
      end

      context 'when the role does not require the telephone number and it is blank' do
        let(:telephone_number) { '' }

        it 'is valid' do
          expect(cognito_admin_user).to be_valid(:enter_user_details)
        end
      end
    end

    context 'when eveything is present and correct' do
      it 'is valid' do
        expect(cognito_admin_user).to be_valid(:enter_user_details)
      end
    end
  end

  describe '#validations on create' do
    let(:attributes) do
      {
        email: email,
        telephone_number: telephone_number,
        roles: roles,
        service_access: service_access
      }
    end
    let(:allow_list_file) { Tempfile.new('allow_list.txt') }
    let(:email_list) { ['email.com'] }
    let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

    before do
      allow_list_file.write(email_list.join("\n"))
      allow_list_file.close
      # rubocop:disable RSpec/AnyInstance
      allow_any_instance_of(AllowedEmailDomain).to receive(:allow_list_file_path).and_return(allow_list_file.path)
      # rubocop:enable RSpec/AnyInstance
    end

    after do
      allow_list_file.unlink
    end

    context 'when validating the email' do
      context 'and the email is nil' do
        let(:email) { '' }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:create)
          expect(cognito_admin_user.errors[:email].first).to eq 'Enter an email address in the correct format, like name@example.com'
        end
      end

      context 'and the email contains an uppercase character' do
        let(:email) { 'uSer@cheemail.com' }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:create)
          expect(cognito_admin_user.errors[:email].first).to eq 'Email address cannot contain any capital letters'
        end
      end

      context 'when the email is not on the allow list' do
        context 'and the current user is super_admin' do
          it 'is valid' do
            expect(cognito_admin_user).to be_valid(:create)
          end
        end

        context 'and the current user is user_admin' do
          let(:current_user_access) { :user_admin }

          it 'is valid' do
            expect(cognito_admin_user).to be_valid(:create)
          end
        end

        context 'and the current user is user_support' do
          let(:current_user_access) { :user_support }

          it 'is invalid and it has the correct error message' do
            expect(cognito_admin_user).not_to be_valid(:create)
            expect(cognito_admin_user.errors[:email].first).to eq 'Email domain is not in the allow list'
          end
        end
      end
    end

    context 'when validating the roles' do
      context 'and the roles empty' do
        let(:roles) { [] }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:create)
          expect(cognito_admin_user.errors[:roles].first).to eq 'Select one role for the user'
        end
      end

      context 'when multiple roles are selected' do
        let(:roles) { %w[buyer ccs_user_admin] }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:create)
          expect(cognito_admin_user.errors[:roles].first).to eq 'Select one role for the user'
        end
      end

      context 'and the roles are not within the users scope' do
        let(:roles) { %w[ccs_employee] }
        let(:current_user_access) { :user_support }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:create)
          expect(cognito_admin_user.errors[:roles].first).to eq 'You do not have the ability to create users with these roles'
        end
      end
    end

    context 'when validating the telephone number' do
      context 'when the phone number is too short' do
        let(:telephone_number) { '0712345678' }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:create)
          expect(cognito_admin_user.errors[:telephone_number].first).to eq 'Enter a UK mobile telephone number, for example 07700900982'
        end
      end

      context 'when the phone number is too long' do
        let(:telephone_number) { '071234567891' }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:create)
          expect(cognito_admin_user.errors[:telephone_number].first).to eq 'Enter a UK mobile telephone number, for example 07700900982'
        end
      end

      context 'when the phone number does not start with 07' do
        let(:telephone_number) { '12345678912' }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:create)
          expect(cognito_admin_user.errors[:telephone_number].first).to eq 'Enter a UK mobile telephone number, for example 07700900982'
        end
      end

      context 'when the role requires the telephone number and it is blank' do
        let(:telephone_number) { '' }
        let(:roles) { %w[allow_list_access] }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:create)
          expect(cognito_admin_user.errors[:telephone_number].first).to eq 'Enter a UK mobile telephone number, for example 07700900982'
        end
      end

      context 'when the role does not require the telephone number and it is blank' do
        let(:telephone_number) { '' }

        it 'is valid' do
          expect(cognito_admin_user).to be_valid(:create)
        end
      end
    end

    context 'when validating the service_access' do
      context 'and the service_access is empty when it required' do
        let(:roles) { %w[ccs_employee] }
        let(:service_access) { [] }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:create)
          expect(cognito_admin_user.errors[:service_access].first).to eq 'You must select the service access for the user if they have the buyer or service admin role'
        end
      end

      context 'and the service_access are not within the list' do
        let(:service_access) { %w[fake_service] }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:create)
          expect(cognito_admin_user.errors[:service_access].first).to eq 'You must select the service access for the user from this list'
        end
      end
    end

    context 'when eveything is present and correct' do
      it 'is valid' do
        expect(cognito_admin_user).to be_valid(:create)
      end
    end
  end

  describe 'validations on an existing user' do
    before { cognito_admin_user.assign_attributes({ attribute => value }) }

    context 'when validating the email status' do
      let(:attribute) { :email_verified }

      context 'when it is nil' do
        let(:value) { nil }

        it 'is invalid' do
          expect(cognito_admin_user).not_to be_valid(:email_verified)
        end
      end

      context 'when it is empty' do
        let(:value) { '' }

        it 'is invalid' do
          expect(cognito_admin_user).not_to be_valid(:email_verified)
        end
      end

      context 'when it is true' do
        let(:value) { 'true' }

        it 'is valid' do
          expect(cognito_admin_user).to be_valid(:email_verified)
        end
      end

      context 'when it is false' do
        let(:value) { 'false' }

        it 'is valid' do
          expect(cognito_admin_user).to be_valid(:email_verified)
        end
      end
    end

    context 'when validating the account status' do
      let(:attribute) { :account_status }

      context 'when it is nil' do
        let(:value) { nil }

        it 'is invalid' do
          expect(cognito_admin_user).not_to be_valid(:account_status)
        end
      end

      context 'when it is empty' do
        let(:value) { '' }

        it 'is invalid' do
          expect(cognito_admin_user).not_to be_valid(:account_status)
        end
      end

      context 'when it is true' do
        let(:value) { 'true' }

        it 'is valid' do
          expect(cognito_admin_user).to be_valid(:account_status)
        end
      end

      context 'when it is false' do
        let(:value) { 'false' }

        it 'is valid' do
          expect(cognito_admin_user).to be_valid(:account_status)
        end
      end
    end

    context 'when validating the telephone number' do
      let(:attribute) { :telephone_number }

      context 'when the phone number is too short' do
        let(:value) { '0712345678' }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:telephone_number)
          expect(cognito_admin_user.errors[:telephone_number].first).to eq 'Enter a UK mobile telephone number, for example 07700900982'
        end
      end

      context 'when the phone number is too long' do
        let(:value) { '071234567891' }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:telephone_number)
          expect(cognito_admin_user.errors[:telephone_number].first).to eq 'Enter a UK mobile telephone number, for example 07700900982'
        end
      end

      context 'when the phone number does not start with 07' do
        let(:value) { '12345678912' }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:telephone_number)
          expect(cognito_admin_user.errors[:telephone_number].first).to eq 'Enter a UK mobile telephone number, for example 07700900982'
        end
      end

      context 'when the phone number is a GB number' do
        let(:value) { '07123456789' }

        it 'is valid' do
          expect(cognito_admin_user).to be_valid(:telephone_number)
        end
      end

      context 'when the role requires the telephone number and it is blank' do
        let(:value) { '' }
        let(:roles) { %w[ccs_employee] }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:create)
          expect(cognito_admin_user.errors[:telephone_number].first).to eq 'Enter a UK mobile telephone number, for example 07700900982'
        end
      end

      context 'when the role does not require the telephone number and it is blank' do
        let(:value) { '' }

        it 'is valid' do
          expect(cognito_admin_user).to be_valid(:create)
        end
      end
    end

    context 'when validating the mfa status' do
      let(:attribute) { :mfa_enabled }

      context 'when it is nil' do
        let(:value) { nil }

        it 'is invalid' do
          expect(cognito_admin_user).not_to be_valid(:mfa_enabled)
        end
      end

      context 'when it is empty' do
        let(:value) { '' }

        it 'is invalid' do
          expect(cognito_admin_user).not_to be_valid(:mfa_enabled)
        end
      end

      context 'when it is true' do
        let(:value) { 'true' }

        context 'and the telephone number is nil' do
          let(:telephone_number) { nil }

          it 'is invalid and it has the correct error message' do
            expect(cognito_admin_user).not_to be_valid(:mfa_enabled)
            expect(cognito_admin_user.errors[:mfa_enabled].first).to eq 'The telephone number of the user must be set to update the MFA configuration'
          end
        end

        context 'and the telephone number is not nil' do
          it 'is valid' do
            expect(cognito_admin_user).to be_valid(:mfa_enabled)
          end
        end
      end

      context 'when it is false' do
        let(:value) { 'false' }

        context 'and the telephone number is nil' do
          let(:telephone_number) { nil }

          it 'is invalid and it has the correct error message' do
            expect(cognito_admin_user).not_to be_valid(:mfa_enabled)
            expect(cognito_admin_user.errors[:mfa_enabled].first).to eq 'The telephone number of the user must be set to update the MFA configuration'
          end
        end

        context 'and one of the roles requires MFA' do
          let(:roles) { %i[allow_list_access] }

          it 'is invalid and it has the correct error message' do
            expect(cognito_admin_user).not_to be_valid(:mfa_enabled)
            expect(cognito_admin_user.errors[:mfa_enabled].first).to eq 'You cannot disable MFA for this user as they have an admin role'
          end
        end

        context 'and the telephone number is not nil' do
          it 'is valid' do
            expect(cognito_admin_user).to be_valid(:mfa_enabled)
          end
        end
      end
    end

    context 'when validating the roles' do
      let(:attribute) { :roles }

      context 'and roles is empty' do
        let(:value) { [] }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:roles)
          expect(cognito_admin_user.errors[:roles].first).to eq 'Select a role for the user'
        end
      end

      context 'and the roles are not within the users scope' do
        let(:current_user_access) { :user_support }
        let(:value) { %w[ccs_employee] }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:roles)
          expect(cognito_admin_user.errors[:roles].first).to eq 'You do not have the ability to create users with these roles'
        end
      end

      context 'and MFA is not enabled when admin roles are present' do
        let(:mfa_enabled) { 'false' }
        let(:value) { %w[buyer ccs_employee] }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:roles)
          expect(cognito_admin_user.errors[:roles].first).to eq 'You must enable MFA for this user to add these admin roles'
        end
      end

      context 'and the roles are within the users scope' do
        let(:current_user_access) { :user_support }
        let(:value) { %w[buyer] }

        it 'is valid' do
          expect(cognito_admin_user).to be_valid(:roles)
        end
      end
    end

    context 'when validating the service_access' do
      let(:attribute) { :service_access }

      context 'and the service_access is empty when it required' do
        let(:value) { [] }

        context 'and the role requires a service' do
          it 'is invalid and it has the correct error message' do
            expect(cognito_admin_user).not_to be_valid(:service_access)
            expect(cognito_admin_user.errors[:service_access].first).to eq 'You must select the service access for the user from this list'
          end
        end

        context 'and the role does not require a service' do
          let(:roles) { %w[user_admin] }

          it 'is invalid and it has the correct error message' do
            expect(cognito_admin_user).not_to be_valid(:service_access)
            expect(cognito_admin_user.errors[:service_access].first).to eq 'You must select the service access for the user from this list'
          end
        end
      end

      context 'and the service_access are not within the list' do
        let(:value) { %w[fake_service] }

        it 'is invalid and it has the correct error message' do
          expect(cognito_admin_user).not_to be_valid(:service_access)
          expect(cognito_admin_user.errors[:service_access].first).to eq 'You must select the service access for the user from this list'
        end
      end

      context 'when there is a service_access' do
        let(:value) { %w[fm_access mc_access] }

        context 'and the role requires it' do
          it 'is valid' do
            expect(cognito_admin_user).to be_valid(:service_access)
          end
        end

        context 'and the role does not require it' do
          let(:roles) { %w[allow_list_access] }

          it 'is valid' do
            expect(cognito_admin_user).to be_valid(:service_access)
          end
        end
      end
    end
  end

  describe '.create' do
    let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

    before { allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client) }

    context 'when a cognito error is made' do
      let(:error) { Aws::CognitoIdentityProvider::Errors::ServiceError }

      before do
        allow(aws_client).to receive(:admin_create_user).and_raise(error.new('Some context', 'Some message'))
        cognito_admin_user.create
      end

      it 'does not return success' do
        expect(cognito_admin_user.success?).to eq false
      end

      it 'returns an error' do
        expect(cognito_admin_user.errors.empty?).to eq false
      end
    end

    # rubocop:disable RSpec/ExampleLength
    context 'when the user is successfully created' do
      before do
        allow(aws_client).to receive(:admin_create_user).and_return(OpenStruct.new(user: { 'username' => cognito_uuid }))
        allow(aws_client).to receive(:admin_set_user_mfa_preference)
        allow(aws_client).to receive(:admin_add_user_to_group)
        cognito_admin_user.create
      end

      context 'and the user is a buyer with fm_access and st_access' do
        let(:service_access) { %w[fm_access st_access] }

        it 'calls admin_create_user with the correct arguments' do
          expect(aws_client).to have_received(:admin_create_user).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: 'user@crowncommercial.gov.uk',
              user_attributes: [
                {
                  name: 'email',
                  value: 'user@crowncommercial.gov.uk'
                },
                {
                  name: 'email_verified',
                  value: 'true'
                }
              ],
              desired_delivery_mediums: ['EMAIL']
            }
          )
        end

        it 'does not call admin_set_user_mfa_preference' do
          expect(aws_client).not_to have_received(:admin_set_user_mfa_preference)
        end

        it 'calls admin_add_user_to_group with the correct arguments' do
          expect(aws_client).to have_received(:admin_add_user_to_group).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              group_name: 'buyer'
            }
          )
          expect(aws_client).to have_received(:admin_add_user_to_group).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              group_name: 'fm_access'
            }
          )
        end

        it 'returns success' do
          expect(cognito_admin_user.success?).to be true
        end

        it 'does not return an error' do
          expect(cognito_admin_user.errors.empty?).to be true
        end
      end

      context 'when the user created is an admin' do
        let(:roles) { %w[ccs_employee] }

        it 'calls admin_create_user with the correct arguments' do
          expect(aws_client).to have_received(:admin_create_user).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: 'user@crowncommercial.gov.uk',
              user_attributes: [
                {
                  name: 'email',
                  value: 'user@crowncommercial.gov.uk'
                },
                {
                  name: 'email_verified',
                  value: 'true'
                },
                {
                  name: 'phone_number',
                  value: '+447123456789'
                }
              ],
              desired_delivery_mediums: ['EMAIL']
            }
          )
        end

        it 'calls admin_set_user_mfa_preference with the correct arguments' do
          expect(aws_client).to have_received(:admin_set_user_mfa_preference).with(
            sms_mfa_settings: {
              enabled: true,
              preferred_mfa: true,
            },
            user_pool_id: 'cognito-user-pool-id',
            username: cognito_uuid,
          )
        end

        it 'calls admin_add_user_to_group with the correct arguments' do
          expect(aws_client).to have_received(:admin_add_user_to_group).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              group_name: 'ccs_employee'
            }
          )
          expect(aws_client).to have_received(:admin_add_user_to_group).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              group_name: 'fm_access'
            }
          )
        end

        it 'does return success' do
          expect(cognito_admin_user.success?).to be true
        end

        it 'does not return an error' do
          expect(cognito_admin_user.errors.empty?).to be true
        end
      end
    end
    # rubocop:enable RSpec/ExampleLength
  end

  describe '.assign_attributes' do
    let(:assign_attributes) { cognito_admin_user.assign_attributes(new_attributes) }

    context 'when new_attributes is nil' do
      let(:new_attributes) { nil }

      it 'raises an argument error' do
        expect { assign_attributes }.to raise_error(ArgumentError)
      end
    end

    context 'when new_attributes is empty' do
      let(:new_attributes) { {} }

      it 'raises does not change the cognito_admin_user' do
        expect(assign_attributes).to be_nil
      end
    end

    context 'when the attribute does not exist' do
      let(:new_attributes) { { my_made_up_attribute: 'hello' } }

      it 'raises an ActiveRecord::UnknownAttributeError error' do
        expect { assign_attributes }.to raise_error(ActiveRecord::UnknownAttributeError)
      end
    end

    context 'when the attribute does exist' do
      let(:new_attributes) { { telephone_number: '07987654321' } }

      it 'updates the cognito_admin_user' do
        expect { assign_attributes }.to change(cognito_admin_user, :telephone_number).from('07123456789').to('07987654321')
      end
    end

    context 'when multiple attributes are assigned' do
      let(:new_attributes) { { telephone_number: '07987654321', mfa_enabled: 'true' } }

      it 'updates the cognito_admin_user' do
        expect { assign_attributes }.to change(cognito_admin_user, :telephone_number).from('07123456789').to('07987654321')
                                    .and change(cognito_admin_user, :mfa_enabled).from(false).to(true)
      end
    end
  end

  describe '.find' do
    let(:cognito_admin_user) { described_class.find(current_user_access, cognito_uuid) }

    let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }
    let(:cognio_enabled) { true }
    let(:cognito_telephone_number) { '+447123456789' }
    let(:cognito_mfa_setting_list) { nil }
    let(:cognito_groups) { %w[buyer fm_access] }

    before do
      allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
      allow(aws_client).to receive(:admin_get_user).and_return(
        OpenStruct.new(
          user_attributes: [
            OpenStruct.new({ name: 'email', value: email }),
            OpenStruct.new({ name: 'phone_number', value: cognito_telephone_number })
          ],
          enabled: cognio_enabled,
          user_status: 'CONFIRMED',
          user_mfa_setting_list: cognito_mfa_setting_list
        )
      )
      allow(aws_client).to receive(:admin_list_groups_for_user).and_return(
        OpenStruct.new(
          groups: cognito_groups.map { |cognito_role| OpenStruct.new(group_name: cognito_role) }
        )
      )
    end

    context 'when considering the attributes' do
      it 'sets the email' do
        expect(cognito_admin_user.email).to eq email
      end

      context 'when looking at the telephone_number' do
        context 'and the telephone number is nil' do
          let(:cognito_telephone_number) { nil }

          it 'sets the telephone number as an empty string' do
            expect(cognito_admin_user.telephone_number).to eq ''
          end
        end

        context 'and the telephone number is not a GB number' do
          let(:cognito_telephone_number) { '+11234567891' }

          it 'sets the telephone number as unchanged' do
            expect(cognito_admin_user.telephone_number).to eq cognito_telephone_number
          end
        end

        context 'and the telephone number is a GB number' do
          it 'sets replaces the area code with 0' do
            expect(cognito_admin_user.telephone_number).to eq '07123456789'
          end
        end
      end

      it 'sets the account status' do
        expect(cognito_admin_user.account_status).to eq true
      end

      it 'sets the confirmation status' do
        expect(cognito_admin_user.confirmation_status).to eq 'CONFIRMED'
      end

      context 'when looking at mfa_enabled' do
        context 'and mfa_enabled telephone number is nil' do
          let(:cognito_mfa_setting_list) { nil }

          it 'sets mfa_enabled as false' do
            expect(cognito_admin_user.mfa_enabled).to be false
          end
        end

        context 'and mfa_enabled telephone number is an empty array' do
          let(:cognito_mfa_setting_list) { [] }

          it 'sets mfa_enabled as false' do
            expect(cognito_admin_user.mfa_enabled).to be false
          end
        end

        context 'and mfa_enabled telephone number is an array with EMAIL_MFA' do
          let(:cognito_mfa_setting_list) { %w[EMAIL_MFA] }

          it 'sets mfa_enabled as false' do
            expect(cognito_admin_user.mfa_enabled).to be false
          end
        end

        context 'and mfa_enabled telephone number is an array with SMS_MFA' do
          let(:cognito_mfa_setting_list) { %w[SMS_MFA] }

          it 'sets mfa_enabled as true' do
            expect(cognito_admin_user.mfa_enabled).to be true
          end
        end
      end

      it 'seperates the groups into roles and service access' do
        expect(cognito_admin_user.roles).to eq %w[buyer]
        expect(cognito_admin_user.service_access).to eq %w[fm_access]
      end

      it 'sets the cognito_roles' do
        expect(cognito_admin_user.cognito_roles).not_to be_nil
      end
    end

    context 'when considering the client calls' do
      before { cognito_admin_user }

      it 'calls admin_get_user with correct arguments' do
        expect(aws_client).to have_received(:admin_get_user).with(
          {
            user_pool_id: 'cognito-user-pool-id',
            username: cognito_uuid,
          }
        )
      end

      it 'calls admin_list_groups_for_user with correct arguments' do
        expect(aws_client).to have_received(:admin_list_groups_for_user).with(
          {
            user_pool_id: 'cognito-user-pool-id',
            username: cognito_uuid,
          }
        )
      end
    end

    context 'and there is an error' do
      before { allow(aws_client).to receive(:admin_get_user).and_raise(Aws::CognitoIdentityProvider::Errors::UserNotFoundException.new('Some context', 'Some message')) }

      it 'does not set any of the atributes' do
        expect(%i[email telephone_number account_status confirmation_status mfa_enabled roles service_access cognito_roles].all? { |attribute| cognito_admin_user.send(attribute).nil? }).to be true
      end

      it 'sets the error' do
        expect(cognito_admin_user.error).to eq 'Some message'
      end
    end
  end

  describe '.search' do
    let(:search) { described_class.search(email) }
    let(:search_users) { search[:users] }
    let(:search_error) { search[:error] }

    let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

    let(:aa_user) { { email: 'aa_user@email.com', cognito_uuid: SecureRandom.uuid, account_status: true } }
    let(:ab_user) { { email: 'ab_user@email.com', cognito_uuid: SecureRandom.uuid, account_status: false } }
    let(:ac_user) { { email: 'ac_user@email.com', cognito_uuid: SecureRandom.uuid, account_status: true } }

    before do
      allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
      allow(aws_client).to receive(:list_users).and_return(
        OpenStruct.new(
          users: [ac_user, ab_user, aa_user].map do |user|
            OpenStruct.new(
              {
                username: user[:cognito_uuid],
                attributes: [OpenStruct.new({ name: 'email', value: user[:email] })],
                enabled: user[:account_status]
              }
            )
          end
        )
      )
    end

    context 'and the email is valid' do
      let(:email) { ' A ' }

      it 'calls the aws client with the right parameters' do
        search

        expect(aws_client).to have_received(:list_users).with(
          {
            user_pool_id: 'cognito-user-pool-id',
            attributes_to_get: ['email'],
            filter: 'email ^= "a"'
          }
        )
      end

      it 'gets the sorted users' do
        expect(search_users).to eq([aa_user, ab_user, ac_user])
      end

      it 'returns no error' do
        expect(search_error).to be_nil
      end
    end

    context 'and the email is invalid because it is empty' do
      let(:email) { '' }

      it 'does not call the aws client with the right parameters' do
        search

        expect(aws_client).not_to have_received(:list_users)
      end

      it 'returns no users' do
        expect(search_users).to be_empty
      end

      it 'returns the error' do
        expect(search_error).to eq 'You must enter an email address'
      end
    end

    context 'and the email is invalid because it is blank' do
      let(:email) { '   ' }

      it 'does not call the aws client with the right parameters' do
        search

        expect(aws_client).not_to have_received(:list_users)
      end

      it 'returns no users' do
        expect(search_users).to be_empty
      end

      it 'returns the error' do
        expect(search_error).to eq 'You must enter an email address'
      end
    end

    context 'and an error is raised' do
      let(:email) { 'a' }

      before { allow(aws_client).to receive(:list_users).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('Some context', 'Some message')) }

      it 'calls the aws client with the right parameters' do
        search

        expect(aws_client).to have_received(:list_users).with(
          {
            user_pool_id: 'cognito-user-pool-id',
            attributes_to_get: ['email'],
            filter: 'email ^= "a"'
          }
        )
      end

      it 'returns no users' do
        expect(search_users).to be_empty
      end

      it 'returns the error' do
        expect(search_error).to eq 'Some message'
      end
    end
  end

  # rubocop:disable RSpec/ExampleLength
  describe 'update' do
    let(:result) { cognito_admin_user.update(method) }

    let(:aws_client) { instance_double(Aws::CognitoIdentityProvider::Client) }

    before { allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client) }

    context 'when updating the email status' do
      let(:method) { :email_verified }

      before { allow(aws_client).to receive(:admin_update_user_attributes) }

      context 'and it is invalid' do
        let(:email_verified) { '' }

        it 'returns false' do
          expect(result).to be false
        end

        it 'does not call admin_update_user_attributes' do
          result

          expect(aws_client).not_to have_received(:admin_update_user_attributes)
        end
      end

      context 'and it raises an AWS error' do
        before { allow(aws_client).to receive(:admin_update_user_attributes).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('Some context', 'Some message')) }

        it 'returns false it has the correct error message' do
          expect(result).to be false
          expect(cognito_admin_user.errors[:email_verified].first).to eq 'Some message'
        end

        it 'calls admin_update_user_attributes with correct arguments' do
          result

          expect(aws_client).to have_received(:admin_update_user_attributes).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              user_attributes: [
                {
                  name: 'email_verified',
                  value: 'true'
                }
              ]
            }
          )
        end
      end

      context 'and it is valid and does not raise an AWS error' do
        it 'returns true' do
          expect(result).to be true
        end

        it 'calls admin_update_user_attributes with correct arguments' do
          result

          expect(aws_client).to have_received(:admin_update_user_attributes).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              user_attributes: [
                {
                  name: 'email_verified',
                  value: 'true'
                }
              ]
            }
          )
        end
      end
    end

    context 'when updating the account status' do
      let(:method) { :account_status }

      before do
        allow(aws_client).to receive(:admin_enable_user)
        allow(aws_client).to receive(:admin_disable_user)
      end

      context 'and it is invalid' do
        let(:account_status) { nil }

        it 'returns false' do
          expect(result).to be false
        end

        it 'does not call admin_enable_user' do
          result

          expect(aws_client).not_to have_received(:admin_enable_user)
        end

        it 'does not call admin_disable_user' do
          result

          expect(aws_client).not_to have_received(:admin_disable_user)
        end
      end

      context 'and it raises an AWS error' do
        before { allow(aws_client).to receive(:admin_enable_user).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('Some context', 'Some message')) }

        it 'returns false it has the correct error message' do
          expect(result).to be false
          expect(cognito_admin_user.errors[:account_status].first).to eq 'Some message'
        end

        it 'calls admin_enable_user with correct arguments' do
          result

          expect(aws_client).to have_received(:admin_enable_user).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid
            }
          )
        end

        it 'does not call admin_disable_user' do
          result

          expect(aws_client).not_to have_received(:admin_disable_user)
        end
      end

      context 'and it is valid and does not raise an AWS error' do
        context 'and the account status is enabled' do
          let(:account_status) { 'true' }

          it 'returns true' do
            expect(result).to be true
          end

          it 'calls admin_enable_user with correct arguments' do
            result

            expect(aws_client).to have_received(:admin_enable_user).with(
              {
                user_pool_id: 'cognito-user-pool-id',
                username: cognito_uuid
              }
            )
          end

          it 'does not call admin_disable_user' do
            result

            expect(aws_client).not_to have_received(:admin_disable_user)
          end
        end

        context 'and the account status is disabled' do
          let(:account_status) { 'false' }

          it 'returns true' do
            expect(result).to be true
          end

          it 'does not call admin_enable_user' do
            result

            expect(aws_client).not_to have_received(:admin_enable_user)
          end

          it 'does not call admin_disable_user' do
            result

            expect(aws_client).to have_received(:admin_disable_user).with(
              {
                user_pool_id: 'cognito-user-pool-id',
                username: cognito_uuid
              }
            )
          end
        end
      end
    end

    context 'when updating the telephone number' do
      let(:method) { :telephone_number }

      before { allow(aws_client).to receive(:admin_update_user_attributes) }

      context 'and it is invalid' do
        let(:telephone_number) { '' }

        it 'returns false it has the correct error message' do
          expect(result).to be false
          expect(cognito_admin_user.errors[:telephone_number].first).to eq 'Enter a UK mobile telephone number, for example 07700900982'
        end

        it 'does not call admin_update_user_attributes' do
          result

          expect(aws_client).not_to have_received(:admin_update_user_attributes)
        end
      end

      context 'and it raises an AWS error' do
        before { allow(aws_client).to receive(:admin_update_user_attributes).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('Some context', 'Some message')) }

        it 'returns false it has the correct error message' do
          expect(result).to be false
          expect(cognito_admin_user.errors[:telephone_number].first).to eq 'Some message'
        end

        it 'calls admin_update_user_attributes with correct arguments' do
          result

          expect(aws_client).to have_received(:admin_update_user_attributes).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              user_attributes: [
                {
                  name: 'phone_number',
                  value: '+447123456789'
                },
                {
                  name: 'phone_number_verified',
                  value: 'true'
                }
              ]
            }
          )
        end
      end

      context 'and it is valid and does not raise an AWS error' do
        it 'returns true' do
          expect(result).to be true
        end

        it 'calls admin_update_user_attributes with correct arguments' do
          result

          expect(aws_client).to have_received(:admin_update_user_attributes).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              user_attributes: [
                {
                  name: 'phone_number',
                  value: '+447123456789'
                },
                {
                  name: 'phone_number_verified',
                  value: 'true'
                }
              ]
            }
          )
        end
      end
    end

    context 'when updating the mfa status' do
      let(:method) { :mfa_enabled }

      before { allow(aws_client).to receive(:admin_set_user_mfa_preference) }

      context 'and it is invalid' do
        let(:mfa_enabled) { nil }

        it 'returns false' do
          expect(result).to be false
        end

        it 'does not call admin_set_user_mfa_preference' do
          result

          expect(aws_client).not_to have_received(:admin_set_user_mfa_preference)
        end
      end

      context 'and it raises an AWS error' do
        before { allow(aws_client).to receive(:admin_set_user_mfa_preference).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('Some context', 'Some message')) }

        it 'returns false it has the correct error message' do
          expect(result).to be false
          expect(cognito_admin_user.errors[:mfa_enabled].first).to eq 'Some message'
        end

        it 'calls admin_set_user_mfa_preference with correct arguments' do
          result

          expect(aws_client).to have_received(:admin_set_user_mfa_preference).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              sms_mfa_settings: {
                enabled: false,
                preferred_mfa: false,
              }
            }
          )
        end
      end

      context 'and it is valid and does not raise an AWS error' do
        let(:mfa_enabled) { 'true' }

        it 'returns true' do
          expect(result).to be true
        end

        it 'calls admin_set_user_mfa_preference with correct arguments' do
          result

          expect(aws_client).to have_received(:admin_set_user_mfa_preference).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              sms_mfa_settings: {
                enabled: true,
                preferred_mfa: true,
              }
            }
          )
        end
      end
    end

    context 'when updating the roles' do
      let(:method) { :roles }
      let(:mfa_enabled) { true }
      let(:roles) { %w[buyer allow_list_access ccs_employee] }
      let(:new_roles) { %w[buyer ccs_user_admin] }

      before do
        cognito_admin_user.assign_attributes(roles: new_roles)
        allow(aws_client).to receive(:admin_remove_user_from_group)
        allow(aws_client).to receive(:admin_add_user_to_group)
      end

      context 'and it is invalid' do
        let(:new_roles) { [] }

        it 'returns false it has the correct error message' do
          expect(result).to be false
          expect(cognito_admin_user.errors[:roles].first).to eq 'Select a role for the user'
        end

        it 'does not call admin_remove_user_from_group or admin_add_user_to_group' do
          result

          expect(aws_client).not_to have_received(:admin_remove_user_from_group)
          expect(aws_client).not_to have_received(:admin_add_user_to_group)
        end
      end

      context 'and it raises an AWS error' do
        before { allow(aws_client).to receive(:admin_remove_user_from_group).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('Some context', 'Some message')) }

        it 'returns false it has the correct error message' do
          expect(result).to be false
          expect(cognito_admin_user.errors[:roles].first).to eq 'Some message'
        end

        it 'calls admin_remove_user_from_group with correct arguments' do
          result

          expect(aws_client).to have_received(:admin_remove_user_from_group).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              group_name: 'allow_list_access'
            }
          )
        end
      end

      context 'and it is valid and does not raise an AWS error' do
        it 'returns true' do
          expect(result).to be true
        end

        it 'calls admin_remove_user_from_group with correct arguments' do
          result

          expect(aws_client).to have_received(:admin_remove_user_from_group).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              group_name: 'allow_list_access'
            }
          )

          expect(aws_client).to have_received(:admin_remove_user_from_group).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              group_name: 'ccs_employee'
            }
          )
        end

        it 'calls admin_add_user_to_group with correct arguments' do
          result

          expect(aws_client).to have_received(:admin_add_user_to_group).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              group_name: 'ccs_user_admin'
            }
          )
        end
      end
    end

    context 'when updating the service_access' do
      let(:method) { :service_access }
      let(:service_access) { %w[fm_access st_access] }
      let(:new_service_access) { %w[fm_access mc_access ls_access] }

      before do
        cognito_admin_user.assign_attributes(service_access: new_service_access)
        allow(aws_client).to receive(:admin_remove_user_from_group)
        allow(aws_client).to receive(:admin_add_user_to_group)
      end

      context 'and it is invalid' do
        let(:new_service_access) { [] }

        it 'returns false it has the correct error message' do
          expect(result).to be false
          expect(cognito_admin_user.errors[:service_access].first).to eq 'You must select the service access for the user from this list'
        end

        it 'does not call admin_remove_user_from_group or admin_add_user_to_group' do
          result

          expect(aws_client).not_to have_received(:admin_remove_user_from_group)
          expect(aws_client).not_to have_received(:admin_add_user_to_group)
        end
      end

      context 'and it raises an AWS error' do
        before { allow(aws_client).to receive(:admin_remove_user_from_group).and_raise(Aws::CognitoIdentityProvider::Errors::ServiceError.new('Some context', 'Some message')) }

        it 'returns false it has the correct error message' do
          expect(result).to be false
          expect(cognito_admin_user.errors[:service_access].first).to eq 'Some message'
        end

        it 'calls admin_remove_user_from_group with correct arguments' do
          result

          expect(aws_client).to have_received(:admin_remove_user_from_group).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              group_name: 'st_access'
            }
          )
        end
      end

      context 'and it is valid and does not raise an AWS error' do
        it 'returns true' do
          expect(result).to be true
        end

        it 'calls admin_remove_user_from_group with correct arguments' do
          result

          expect(aws_client).to have_received(:admin_remove_user_from_group).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              group_name: 'st_access'
            }
          )
        end

        it 'calls admin_add_user_to_group with correct arguments' do
          result

          expect(aws_client).to have_received(:admin_add_user_to_group).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              group_name: 'mc_access'
            }
          )

          expect(aws_client).to have_received(:admin_add_user_to_group).with(
            {
              user_pool_id: 'cognito-user-pool-id',
              username: cognito_uuid,
              group_name: 'ls_access'
            }
          )
        end
      end
    end
  end
  # rubocop:enable RSpec/ExampleLength
end
# rubocop:enable RSpec/NestedGroups
