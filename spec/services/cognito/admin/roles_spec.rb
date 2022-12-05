require 'rails_helper'

RSpec.describe Cognito::Admin::Roles do
  let(:cognito_roles) { described_class.new(user_access, roles, service_access) }

  let(:user_access) { :super_admin }
  let(:roles) { [] }
  let(:service_access) { [] }

  describe 'validations' do
    # rubocop:disable RSpec/NestedGroups
    context 'when validating the role selection' do
      let(:result) { cognito_roles.role_selection_valid }

      context 'and the current user is an user_support user' do
        let(:user_access) { :user_support }

        context 'and no roles are given' do
          it 'returns :role_selection_required' do
            expect(result).to eq :role_selection_required
          end
        end

        context 'and only buyer is given' do
          let(:roles) { %w[buyer] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and ccs_employee is given' do
          let(:roles) { %w[ccs_employee] }

          it 'returns :invalid_role_selection' do
            expect(result).to eq :invalid_role_selection
          end
        end

        context 'and ccs_user_admin is given' do
          let(:roles) { %w[ccs_user_admin] }

          it 'returns :invalid_role_selection' do
            expect(result).to eq :invalid_role_selection
          end
        end

        context 'and buyer is given with ccs_employee and allow_list_access' do
          let(:roles) { %w[buyer ccs_employee allow_list_access] }

          it 'returns :invalid_role_selection' do
            expect(result).to eq :invalid_role_selection
          end
        end

        context 'and all 4 roles are given' do
          let(:roles) { %w[buyer ccs_employee allow_list_access ccs_user_admin] }

          it 'returns :invalid_role_selection' do
            expect(result).to eq :invalid_role_selection
          end
        end
      end

      context 'and the current user is a user_admin user' do
        let(:user_access) { :user_admin }

        context 'and no roles are given' do
          it 'returns :role_selection_required' do
            expect(result).to eq :role_selection_required
          end
        end

        context 'and only buyer is given' do
          let(:roles) { %w[buyer] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and ccs_employee is given' do
          let(:roles) { %w[ccs_employee] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and ccs_user_admin is given' do
          let(:roles) { %w[ccs_user_admin] }

          it 'returns :invalid_role_selection' do
            expect(result).to eq :invalid_role_selection
          end
        end

        context 'and buyer is given with ccs_employee and allow_list_access' do
          let(:roles) { %w[buyer ccs_employee allow_list_access] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and all 4 roles are given' do
          let(:roles) { %w[buyer ccs_employee allow_list_access ccs_user_admin] }

          it 'returns :invalid_role_selection' do
            expect(result).to eq :invalid_role_selection
          end
        end
      end

      context 'and the current user is a super_admin user' do
        let(:user_access) { :super_admin }

        context 'and no roles are given' do
          it 'returns :role_selection_required' do
            expect(result).to eq :role_selection_required
          end
        end

        context 'and only buyer is given' do
          let(:roles) { %w[buyer] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and ccs_employee is given' do
          let(:roles) { %w[ccs_employee] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and ccs_user_admin is given' do
          let(:roles) { %w[ccs_user_admin] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and buyer is given with ccs_employee and allow_list_access' do
          let(:roles) { %w[buyer ccs_employee allow_list_access] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and all 4 roles are given' do
          let(:roles) { %w[buyer ccs_employee allow_list_access ccs_user_admin] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end
      end
    end

    context 'when validating the service_access selection' do
      let(:result) { cognito_roles.service_access_selection_valid }

      context 'when there are no roles' do
        context 'and the service access is empty' do
          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and the service access has an item in the list' do
          let(:service_access) { %w[st_access] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and the service access has items in the list' do
          let(:service_access) { %w[st_access fm_access] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and the service access has an item that is not in the list' do
          let(:service_access) { %w[st_access fm_access buyer] }

          it 'returns :invalid_service_access_selection' do
            expect(result).to eq :invalid_service_access_selection
          end
        end
      end

      context 'when the role is buyer' do
        let(:roles) { %w[buyer] }

        context 'and the service access is empty' do
          it 'returns :service_access_selection_required' do
            expect(result).to eq :service_access_selection_required
          end
        end

        context 'and the service access has an item in the list' do
          let(:service_access) { %w[fm_access] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and the service access has items in the list' do
          let(:service_access) { %w[fm_access ls_access] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and the service access has an item that is not in the list' do
          let(:service_access) { %w[fm_access ls_access ccs_employee] }

          it 'returns :invalid_service_access_selection' do
            expect(result).to eq :invalid_service_access_selection
          end
        end
      end

      context 'when the role is ccs_employee' do
        let(:roles) { %w[ccs_employee] }

        context 'and the service access is empty' do
          it 'returns :service_access_selection_required' do
            expect(result).to eq :service_access_selection_required
          end
        end

        context 'and the service access has an item in the list' do
          let(:service_access) { %w[ls_access] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and the service access has items in the list' do
          let(:service_access) { %w[ls_access mc_access] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and the service access has an item that is not in the list' do
          let(:service_access) { %w[ls_access mc_access allow_list_access] }

          it 'returns :invalid_service_access_selection' do
            expect(result).to eq :invalid_service_access_selection
          end
        end
      end

      context 'when the role is allow_list_access' do
        let(:roles) { %w[allow_list_access] }

        context 'and the service access is empty' do
          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and the service access has an item in the list' do
          let(:service_access) { %w[mc_access] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and the service access has items in the list' do
          let(:service_access) { %w[mc_access st_access] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and the service access has an item that is not in the list' do
          let(:service_access) { %w[mc_access st_access supplier] }

          it 'returns :invalid_service_access_selection' do
            expect(result).to eq :invalid_service_access_selection
          end
        end
      end

      context 'when the role is ccs_user_admin' do
        let(:roles) { %w[ccs_user_admin] }

        context 'and the service access is empty' do
          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and the service access has an item in the list' do
          let(:service_access) { %w[st_access] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and the service access has items in the list' do
          let(:service_access) { %w[st_access ls_access] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and the service access has an item that is not in the list' do
          let(:service_access) { %w[st_access ls_access ccs_developer] }

          it 'returns :invalid_service_access_selection' do
            expect(result).to eq :invalid_service_access_selection
          end
        end
      end

      context 'when the role is buyer with allow_list_access' do
        let(:roles) { %w[buyer allow_list_access] }

        context 'and the service access is empty' do
          it 'returns :service_access_selection_required' do
            expect(result).to eq :service_access_selection_required
          end
        end

        context 'and the service access has an item in the list' do
          let(:service_access) { %w[fm_access] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and the service access has items in the list' do
          let(:service_access) { %w[fm_access mc_access] }

          it 'returns nil' do
            expect(result).to be_nil
          end
        end

        context 'and the service access has an item that is not in the list' do
          let(:service_access) { %w[fm_access mc_access supplier] }

          it 'returns :invalid_service_access_selection' do
            expect(result).to eq :invalid_service_access_selection
          end
        end
      end
    end
    # rubocop:enable RSpec/NestedGroups
  end

  describe '.combine_roles' do
    let(:result) { cognito_roles.combine_roles.sort }

    context 'when the role is buyer with fm_access' do
      let(:roles) { %w[buyer] }
      let(:service_access) { %w[fm_access] }

      it 'returns buyer and fm_access' do
        expect(result).to eq %w[buyer fm_access]
      end
    end

    context 'when the role is ccs_employee with st_access' do
      let(:roles) { %w[ccs_employee] }
      let(:service_access) { %w[st_access] }

      it 'returns ccs_employee and st_access' do
        expect(result).to eq %w[ccs_employee st_access]
      end
    end

    context 'when the role is ccs_employee withouth any service_access' do
      let(:roles) { %w[allow_list_access] }

      it 'returns allow_list_access' do
        expect(result).to eq %w[allow_list_access]
      end
    end

    context 'when the role is ccs_user_admin withouth any service_access' do
      let(:roles) { %w[ccs_user_admin] }

      it 'returns ccs_user_admin' do
        expect(result).to eq %w[ccs_user_admin]
      end
    end

    context 'when the all roles and service_access are passed' do
      let(:roles) { %w[buyer ccs_employee allow_list_access ccs_user_admin] }
      let(:service_access) { %w[st_access fm_access ls_access mc_access] }

      it 'returns allow_list_access, buyer, ccs_employee, ccs_user_admin, fm_access, ls_access, mc_access and st_access' do
        expect(result).to eq %w[allow_list_access buyer ccs_employee ccs_user_admin fm_access ls_access mc_access st_access]
      end
    end
  end

  describe '.admin_roles_present?' do
    let(:result) { cognito_roles.admin_roles_present? }

    context 'when roles are empty' do
      it 'returns false' do
        expect(result).to be false
      end
    end

    context 'when only buyer is present' do
      let(:roles) { %w[buyer] }

      it 'returns false' do
        expect(result).to be false
      end
    end

    context 'when only ccs_employee is present' do
      let(:roles) { %w[ccs_employee] }

      it 'returns true' do
        expect(result).to be true
      end
    end

    context 'when buyer and allow_list_access is present' do
      let(:roles) { %w[buyer allow_list_access] }

      it 'returns true' do
        expect(result).to be true
      end
    end

    context 'and all 4 roles are present' do
      let(:roles) { %w[buyer ccs_employee allow_list_access ccs_user_admin] }

      it 'returns true' do
        expect(result).to be true
      end
    end
  end

  describe '.application_role_locations' do
    let(:result) { cognito_roles.application_role_locations }

    context 'when only buyer is present' do
      let(:roles) { %w[buyer] }

      context 'and fm_access is present' do
        let(:service_access) { %w[fm_access] }

        it 'returns main' do
          expect(result).to eq %i[main]
        end
      end

      context 'and st_access is present' do
        let(:service_access) { %w[st_access] }

        it 'returns legacy' do
          expect(result).to eq %i[legacy]
        end
      end

      context 'and fm_access and st_access are present' do
        let(:service_access) { %w[fm_access st_access] }

        it 'returns main and legacy' do
          expect(result).to eq %i[main legacy]
        end
      end
    end

    context 'when only ccs_employee is present' do
      let(:roles) { %w[ccs_employee] }

      context 'and fm_access is present' do
        let(:service_access) { %w[fm_access] }

        it 'returns main' do
          expect(result).to eq %i[main]
        end
      end

      context 'and ls_access is present' do
        let(:service_access) { %w[ls_access] }

        it 'returns legacy' do
          expect(result).to eq %i[legacy]
        end
      end

      context 'and fm_access and ls_access are present' do
        let(:service_access) { %w[fm_access ls_access] }

        it 'returns main and legacy' do
          expect(result).to eq %i[main legacy]
        end
      end
    end

    context 'when only allow_list_access is present' do
      let(:roles) { %w[allow_list_access] }

      context 'and fm_access is present' do
        let(:service_access) { %w[fm_access] }

        it 'returns main' do
          expect(result).to eq %i[main]
        end
      end

      context 'and mc_access is present' do
        let(:service_access) { %w[mc_access] }

        it 'returns main' do
          expect(result).to eq %i[main]
        end
      end

      context 'and fm_access and mc_access are present' do
        let(:service_access) { %w[fm_access mc_access] }

        it 'returns main' do
          expect(result).to eq %i[main]
        end
      end
    end

    context 'when only ccs_user_admin is present' do
      let(:roles) { %w[ccs_user_admin] }

      context 'and fm_access is present' do
        let(:service_access) { %w[fm_access] }

        it 'returns main' do
          expect(result).to eq %i[main]
        end
      end

      context 'and st_access is present' do
        let(:service_access) { %w[st_access] }

        it 'returns main' do
          expect(result).to eq %i[main]
        end
      end

      context 'and fm_access and st_access are present' do
        let(:service_access) { %w[fm_access st_access] }

        it 'returns main' do
          expect(result).to eq %i[main]
        end
      end
    end

    context 'when ccs_employee and ccs_user_admin is present' do
      let(:roles) { %w[ccs_employee ccs_user_admin] }

      context 'and fm_access is present' do
        let(:service_access) { %w[fm_access] }

        it 'returns main' do
          expect(result).to eq %i[main]
        end
      end

      context 'and st_access is present' do
        let(:service_access) { %w[st_access] }

        it 'returns legacy' do
          expect(result).to eq %i[legacy]
        end
      end

      context 'and fm_access and st_access are present' do
        let(:service_access) { %w[fm_access st_access] }

        it 'returns main and legacy' do
          expect(result).to eq %i[main legacy]
        end
      end
    end
  end

  describe '.get_roles_and_service_access_from_cognito_roles' do
    let(:result) { described_class.get_roles_and_service_access_from_cognito_roles(cognio_roles) }

    context 'when the cognio_roles are buyer with fm_access' do
      let(:cognio_roles) { %w[buyer fm_access] }

      it 'returns buyer for the roles and fm_access for the service_access' do
        expect(result).to eq [%w[buyer], %w[fm_access]]
      end
    end

    context 'when the cognio_roles is ccs_employee with st_access' do
      let(:cognio_roles) { %w[ccs_employee st_access] }

      it 'returns ccs_employee for the roles and st_access for the service_access' do
        expect(result).to eq [%w[ccs_employee], %w[st_access]]
      end
    end

    context 'when the cognio_roles is ccs_employee' do
      let(:cognio_roles) { %w[allow_list_access] }

      it 'returns allow_list_access for the roles and nothing for the service_access' do
        expect(result).to eq [%w[allow_list_access], []]
      end
    end

    context 'when the cognio_roles is ccs_user_admin and allow_list_access and the service_access is fm_access and mc_access' do
      let(:cognio_roles) { %w[ccs_user_admin fm_access allow_list_access mc_access] }

      it 'returns allow_list_access and ccs_user_admin for the roles and fm_access and mc_access for the service_access' do
        expect(result).to eq [%w[allow_list_access ccs_user_admin], %w[fm_access mc_access]]
      end
    end

    context 'when the cognio_roles is all the roles' do
      let(:cognio_roles) { %w[buyer ccs_employee allow_list_access ccs_user_admin st_access fm_access ls_access mc_access] }

      it 'returns buyer, ccs_employee, allow_list_access and ccs_user_admin for the roles and fm_access, st_access, ls_access and mc_access for the service_access' do
        expect(result).to eq [%w[buyer ccs_employee allow_list_access ccs_user_admin], %w[fm_access st_access ls_access mc_access]]
      end
    end
  end

  describe '.current_user_access' do
    let(:user) { create(:user, roles: user_roles) }
    let(:result) { described_class.current_user_access(Ability.new(user)) }

    context 'when the user has buyer access only' do
      let(:user_roles) { %i[buyer] }

      it 'returns nil' do
        expect(result).to be_nil
      end
    end

    context 'when the user has ccs_employee access only' do
      let(:user_roles) { %i[ccs_employee] }

      it 'returns nil' do
        expect(result).to be_nil
      end
    end

    context 'when the user has allow_list access only' do
      let(:user_roles) { %i[allow_list_access] }

      it 'returns user_support' do
        expect(result).to eq :user_support
      end
    end

    context 'when the user has ccs_user_admin access only' do
      let(:user_roles) { %i[ccs_user_admin] }

      it 'returns user_admin' do
        expect(result).to eq :user_admin
      end
    end

    context 'when the user has ccs_developer access only' do
      let(:user_roles) { %i[ccs_developer] }

      it 'returns super_admin' do
        expect(result).to eq :super_admin
      end
    end

    context 'when the user has buyer, ccs_developer, ccs_employee and allow_list access' do
      let(:user_roles) { %i[ccs_employee allow_list_access ccs_developer] }

      it 'returns super_admin' do
        expect(result).to eq :super_admin
      end
    end
  end

  describe '.find_available_roles' do
    let(:result) { described_class.find_available_roles(user_access) }

    context 'when the user access is nil' do
      let(:user_access) { nil }

      it 'has no roles available' do
        expect(result).to be_empty
      end
    end

    context 'when the user access is user_support' do
      let(:user_access) { :user_support }

      it 'has buyer available' do
        expect(result).to eq %w[buyer]
      end
    end

    context 'when the user access is user_admin' do
      let(:user_access) { :user_admin }

      it 'has buyer, ccs_employee and allow_list_access available' do
        expect(result).to eq %w[buyer ccs_employee allow_list_access]
      end
    end

    context 'when the user access is super_admin' do
      let(:user_access) { :super_admin }

      it 'has buyer, ccs_employee, allow_list_access and ccs_user_admin available' do
        expect(result).to eq %w[buyer ccs_employee allow_list_access ccs_user_admin]
      end
    end
  end

  describe '.array_of_users_that_could_edit' do
    let(:result) { cognito_roles.array_of_users_that_could_edit }

    context 'when the user is a buyer' do
      let(:roles) { %w[buyer] }

      it 'returns user support, user admin and super admin ' do
        expect(result).to eq %i[user_support user_admin super_admin]
      end
    end

    context 'when the user is a User Support' do
      let(:roles) { %w[allow_list_access] }

      it 'returns user admin and super admin ' do
        expect(result).to eq %i[user_admin super_admin]
      end
    end

    context 'when the user is a User Admin' do
      let(:roles) { %w[ccs_user_admin] }

      it 'returns a super_admin' do
        expect(result).to eq [:super_admin]
      end
    end

    context 'when the user is a ccs_developer' do
      let(:roles) { %w[ccs_developer] }

      it 'returns a blank array' do
        expect(result).to eq []
      end
    end

    context 'when the user is a ccs_developer and a User Admin' do
      let(:roles) { %w[ccs_developer ccs_user_admin] }

      it 'returns a blank array' do
        expect(result).to eq []
      end
    end

    context 'when the user is a Buyer and a User Support' do
      let(:roles) { %w[buyer allow_list_access] }

      it 'returns user admin and super admin' do
        expect(result).to eq %i[user_admin super_admin]
      end
    end
  end

  describe '.minimum_editor_role' do
    let(:result) { cognito_roles.minimum_editor_role }

    context 'when the user is a buyer' do
      let(:roles) { %w[buyer] }

      it 'returns User Support translation' do
        expect(result).to eq 'allow_list_access'
      end
    end

    context 'when the user is a User Support' do
      let(:roles) { %w[allow_list_access] }

      it 'returns user admin translation' do
        expect(result).to eq 'ccs_user_admin'
      end
    end

    context 'when the user is a User Admin' do
      let(:roles) { %w[ccs_user_admin] }

      it 'returns super admin translation' do
        expect(result).to eq 'ccs_developer'
      end
    end

    context 'when the user is a ccs_developer' do
      let(:roles) { %w[ccs_developer] }

      it 'returns nil' do
        expect(result).to eq nil
      end
    end

    context 'when the user is a ccs_developer and a User Admin' do
      let(:roles) { %w[ccs_developer ccs_user_admin] }

      it 'returns nil' do
        expect(result).to eq nil
      end
    end

    context 'when the user is a Buyer and a User Support' do
      let(:roles) { %w[buyer allow_list_access] }

      it 'returns user admin translation' do
        expect(result).to eq 'ccs_user_admin'
      end
    end
  end
end
