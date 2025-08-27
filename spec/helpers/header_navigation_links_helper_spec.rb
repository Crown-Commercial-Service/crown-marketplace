require 'rails_helper'

RSpec.describe HeaderNavigationLinksHelper do
  describe '#service_name_text' do
    let(:result) { helper.service_name_text }

    before { helper.params[:service] = service }

    context 'when the service is crown_marketplace' do
      let(:service) { 'crown_marketplace' }

      it 'returns Crown Marketplace' do
        expect(result).to eq('Crown Marketplace')
      end
    end

    context 'when the service is facilities_management/admin' do
      let(:service) { 'facilities_management/admin' }

      it 'returns Managing framework and supplier data' do
        expect(result).to eq('Managing framework and supplier data')
      end
    end

    context 'when the service is facilities_management/supplier' do
      let(:service) { 'facilities_management/supplier' }

      it 'returns Facilities management supplier account' do
        expect(result).to eq('Facilities management supplier account')
      end
    end

    context 'when the service is facilities_management' do
      let(:service) { 'facilities_management' }

      it 'returns Find a facilities management supplier' do
        expect(result).to eq('Find a facilities management supplier')
      end
    end

    context 'when the service is something else' do
      let(:service) { 'management_consultancy' }

      it 'returns Find a facilities management supplier' do
        expect(result).to eq('Find a facilities management supplier')
      end
    end
  end

  describe '#service_authentication_links' do
    let(:result) { helper.service_authentication_links }

    before do
      helper.params[:service] = service
      allow(helper).to receive(:service_path_base).and_return(service_path_base)
    end

    context 'when signed in' do
      before { allow(helper).to receive(:user_signed_in?).and_return(true) }

      context 'when the service is facilities_management' do
        let(:service_path_base) { '/facilities-management' }
        let(:service) { 'facilities_management' }

        it 'returns the sign out link with the right options' do
          expect(result).to eq(
            [
              { text: 'Sign out', href: '/facilities-management/sign-out', method: :delete }
            ]
          )
        end
      end

      context 'when the service is facilities_management/admin' do
        let(:service_path_base) { '/facilities-management/admin' }
        let(:service) { 'facilities_management/admin' }

        it 'returns the sign out link with the right options' do
          expect(result).to eq(
            [
              { text: 'Sign out', href: '/facilities-management/admin/sign-out', method: :delete }
            ]
          )
        end
      end

      context 'when the service is facilities_management/supplier' do
        let(:service_path_base) { '/facilities-management/supplier' }
        let(:service) { 'facilities_management/supplier' }

        it 'returns the sign out link with the right options' do
          expect(result).to eq(
            [
              { text: 'Sign out', href: '/facilities-management/supplier/sign-out', method: :delete }
            ]
          )
        end
      end

      context 'when the service is crown_marketplace' do
        let(:service_path_base) { '/crown-marketplace' }
        let(:service) { 'crown_marketplace' }

        it 'returns the sign out link with the right options' do
          expect(result).to eq(
            [
              { text: 'Sign out', href: '/crown-marketplace/sign-out', method: :delete }
            ]
          )
        end
      end
    end

    context 'when signed out' do
      before { allow(helper).to receive(:user_signed_in?).and_return(false) }

      context 'when the service is facilities_management' do
        let(:service_path_base) { '/facilities-management' }
        let(:service) { 'facilities_management' }

        it 'returns the create account and sign in link' do
          expect(result).to eq(
            [
              { text: 'Create an account', href: '/facilities-management/sign-up', active: false },
              { text: 'Sign in', href: '/facilities-management/sign-in', active: false }
            ]
          )
        end
      end

      context 'when the service is facilities_management/admin' do
        let(:service_path_base) { '/facilities-management/admin' }
        let(:service) { 'facilities_management/admin' }

        it 'returns the sign in link' do
          expect(result).to eq(
            [
              { text: 'Sign in', href: '/facilities-management/admin/sign-in', active: false }
            ]
          )
        end
      end

      context 'when the service is facilities_management/supplier' do
        let(:service_path_base) { '/facilities-management/supplier' }
        let(:service) { 'facilities_management/supplier' }

        it 'returns the sign in link' do
          expect(result).to eq(
            [
              { text: 'Sign in', href: '/facilities-management/supplier/sign-in', active: false }
            ]
          )
        end
      end

      context 'when the service is crown_marketplace' do
        let(:service_path_base) { '/crown-marketplace' }
        let(:service) { 'crown_marketplace' }

        it 'returns the sign in link' do
          expect(result).to eq(
            [
              { text: 'Sign in', href: '/crown-marketplace/sign-in', active: false }
            ]
          )
        end
      end
    end
  end

  # rubocop:disable RSpec/NestedGroups
  describe '#service_navigation_links' do
    let(:result) { helper.service_navigation_links }

    before do
      helper.params[:service] = service

      allow(helper).to receive_messages(user_signed_in?: false, service_path_base: service_path_base, current_page?: false)
      allow(controller).to receive_messages(controller_name:, action_name:)
    end

    context 'when the service is crown_marketplace' do
      let(:service_path_base) { '/crown-marketplace' }
      let(:service) { 'crown_marketplace' }

      context 'when on a sign in page' do
        let(:controller_name) { 'sessions' }
        let(:action_name) { 'new' }

        it 'returns the sign in link' do
          expect(result).to eq(
            [
              { text: 'Sign in', href: '/crown-marketplace/sign-in', active: false }
            ]
          )
        end
      end

      context 'when on a dashboard page' do
        let(:controller_name) { 'home' }
        let(:action_name) { 'index' }

        it 'returns the sign out link with the right options' do
          expect(result).to eq(
            [
              { text: 'Sign in', href: '/crown-marketplace/sign-in', active: false }
            ]
          )
        end
      end

      context 'when not on a sign in or dashboard page' do
        context 'when on a password page' do
          let(:controller_name) { 'passwords' }
          let(:action_name) { 'new' }

          it 'returns the back to start and sign out link' do
            expect(result).to eq(
              [
                { text: 'Back to start', href: '/crown-marketplace' },
                { text: 'Sign in', href: '/crown-marketplace/sign-in', active: false }
              ]
            )
          end
        end

        context 'when not signed in' do
          let(:controller_name) { 'manage_users' }
          let(:action_name) { 'index' }

          it 'returns the back to start link' do
            expect(result).to eq(
              [
                { text: 'Back to start', href: '/crown-marketplace' },
                { text: 'Sign in', href: '/crown-marketplace/sign-in', active: false }
              ]
            )
          end
        end

        context 'when signed in' do
          let(:controller_name) { 'manage_users' }
          let(:action_name) { 'index' }

          before { allow(helper).to receive(:user_signed_in?).and_return(true) }

          it 'returns the Crown Marketplace dashboard link' do
            expect(result).to eq(
              [
                { text: 'Crown Marketplace dashboard', href: '/crown-marketplace' },
                { text: 'Sign out', href: '/crown-marketplace/sign-out', method: :delete }
              ]
            )
          end
        end
      end
    end

    context 'when the service is facilities_management/admin' do
      let(:service_path_base) { '/facilities-management/admin' }
      let(:service) { 'facilities_management/admin' }

      context 'when on a sign in page' do
        let(:controller_name) { 'sessions' }
        let(:action_name) { 'new' }

        it 'returns the sign in link' do
          expect(result).to eq(
            [
              { text: 'Sign in', href: '/facilities-management/admin/sign-in', active: false }
            ]
          )
        end
      end

      context 'when on a dashboard page' do
        let(:controller_name) { 'home' }
        let(:action_name) { 'index' }

        it 'returns the sign in link' do
          expect(result).to eq(
            [
              { text: 'Sign in', href: '/facilities-management/admin/sign-in', active: false }
            ]
          )
        end
      end

      context 'when not on a sign in or dashboard page' do
        context 'when on a password page' do
          let(:controller_name) { 'passwords' }
          let(:action_name) { 'new' }

          it 'returns the back to start link' do
            expect(result).to eq(
              [
                { text: 'Back to start', href: '/facilities-management/admin' },
                { text: 'Sign in', href: '/facilities-management/admin/sign-in', active: false }
              ]
            )
          end
        end

        context 'when not signed in' do
          let(:controller_name) { 'uploads' }
          let(:action_name) { 'index' }

          it 'returns the back to start link' do
            expect(result).to eq(
              [
                { text: 'Back to start', href: '/facilities-management/admin' },
                { text: 'Sign in', href: '/facilities-management/admin/sign-in', active: false }
              ]
            )
          end
        end

        context 'when signed in' do
          let(:controller_name) { 'uploads' }
          let(:action_name) { 'index' }

          before { allow(helper).to receive(:user_signed_in?).and_return(true) }

          it 'returns the Admin dashboard link' do
            expect(result).to eq(
              [
                { text: 'Admin dashboard', href: '/facilities-management/admin' },
                { text: 'Sign out', href: '/facilities-management/admin/sign-out', method: :delete }
              ]
            )
          end
        end
      end
    end

    context 'when the service is facilities_management/supplier' do
      let(:service_path_base) { '/facilities-management/supplier' }
      let(:service) { 'facilities_management/supplier' }

      context 'when on a sign in page' do
        let(:controller_name) { 'sessions' }
        let(:action_name) { 'new' }

        it 'returns the sign in link' do
          expect(result).to eq(
            [
              { text: 'Sign in', href: '/facilities-management/supplier/sign-in', active: false }
            ]
          )
        end
      end

      context 'when on a dashboard page' do
        let(:controller_name) { 'dashboard' }
        let(:action_name) { 'index' }

        it 'returns the sign in link' do
          expect(result).to eq(
            [
              { text: 'Sign in', href: '/facilities-management/supplier/sign-in', active: false }
            ]
          )
        end
      end

      context 'when not on a sign in or dashboard page' do
        context 'when on a password page' do
          let(:controller_name) { 'passwords' }
          let(:action_name) { 'new' }

          it 'returns the back to start link' do
            expect(result).to eq(
              [
                { text: 'Back to start', href: '/facilities-management/supplier' },
                { text: 'Sign in', href: '/facilities-management/supplier/sign-in', active: false }
              ]
            )
          end
        end

        context 'when not signed in' do
          let(:controller_name) { 'contracts' }
          let(:action_name) { 'index' }

          it 'returns the back to start link' do
            expect(result).to eq(
              [
                { text: 'Back to start', href: '/facilities-management/supplier' },
                { text: 'Sign in', href: '/facilities-management/supplier/sign-in', active: false }
              ]
            )
          end
        end

        context 'when signed in' do
          let(:controller_name) { 'contracts' }
          let(:action_name) { 'index' }

          before { allow(helper).to receive(:user_signed_in?).and_return(true) }

          it 'returns the My dashboard link' do
            expect(result).to eq(
              [
                { text: 'My dashboard', href: '/facilities-management/supplier' },
                { text: 'Sign out', href: '/facilities-management/supplier/sign-out', method: :delete }
              ]
            )
          end
        end
      end
    end

    context 'when the service is facilities_management' do
      let(:service_path_base) { '/facilities-management' }
      let(:service) { 'facilities_management' }
      let(:current_user_obj) { instance_double(User) }

      context 'when on the fm landing page' do
        let(:controller_name) { 'home' }
        let(:action_name) { 'index' }

        it 'returns the create account and sign in link' do
          expect(result).to eq(
            [
              { text: 'Create an account', href: '/facilities-management/sign-up', active: false },
              { text: 'Sign in', href: '/facilities-management/sign-in', active: false }
            ]
          )
        end
      end

      context 'when on the buyer account page' do
        let(:controller_name) { 'buyer_account' }
        let(:action_name) { 'index' }

        it 'returns the create account and sign in link' do
          expect(result).to eq(
            [
              { text: 'Create an account', href: '/facilities-management/sign-up', active: false },
              { text: 'Sign in', href: '/facilities-management/sign-in', active: false }
            ]
          )
        end
      end

      context 'when on the not permitted page' do
        let(:controller_name) { 'home' }
        let(:action_name) { 'not_permitted' }

        context 'when not signed in' do
          it 'returns the create account and sign in link' do
            expect(result).to eq(
              [
                { text: 'Create an account', href: '/facilities-management/sign-up', active: false },
                { text: 'Sign in', href: '/facilities-management/sign-in', active: false }
              ]
            )
          end
        end

        context 'when signed in' do
          before { allow(helper).to receive(:user_signed_in?).and_return(true) }

          it 'returns the My account link' do
            expect(result).to eq(
              [
                { text: 'My account', href: '/facilities-management' },
                { text: 'Sign out', href: '/facilities-management/sign-out', method: :delete }
              ]
            )
          end
        end
      end

      context 'when not signed in' do
        before { allow(helper).to receive(:current_user).and_return(nil) }

        context 'when on a buyer account page' do
          let(:buyer_account) { 'home' }
          let(:action_name) { 'index' }

          it 'returns the Back to start link' do
            expect(result).to eq(
              [
                { text: 'Back to start', href: '/facilities-management/start' },
                { text: 'Create an account', href: '/facilities-management/sign-up', active: false },
                { text: 'Sign in', href: '/facilities-management/sign-in', active: false }
              ]
            )
          end
        end

        context 'when on a session page' do
          let(:buyer_account) { 'sessions' }
          let(:action_name) { 'new' }

          it 'returns the Back to start link' do
            expect(result).to eq(
              [
                { text: 'Back to start', href: '/facilities-management/start' },
                { text: 'Create an account', href: '/facilities-management/sign-up', active: false },
                { text: 'Sign in', href: '/facilities-management/sign-in', active: false }
              ]
            )
          end
        end

        context 'when on a registrations page' do
          let(:buyer_account) { 'registrations' }
          let(:action_name) { 'new' }

          it 'returns the Back to start link' do
            expect(result).to eq(
              [
                { text: 'Back to start', href: '/facilities-management/start' },
                { text: 'Create an account', href: '/facilities-management/sign-up', active: false },
                { text: 'Sign in', href: '/facilities-management/sign-in', active: false }
              ]
            )
          end
        end

        context 'when on a passwords page' do
          let(:buyer_account) { 'passwords' }
          let(:action_name) { 'new' }

          it 'returns the Back to start link' do
            expect(result).to eq(
              [
                { text: 'Back to start', href: '/facilities-management/start' },
                { text: 'Create an account', href: '/facilities-management/sign-up', active: false },
                { text: 'Sign in', href: '/facilities-management/sign-in', active: false }
              ]
            )
          end
        end

        context 'when on a users page' do
          let(:buyer_account) { 'users' }
          let(:action_name) { 'confirm_new' }

          it 'returns the Back to start link' do
            expect(result).to eq(
              [
                { text: 'Back to start', href: '/facilities-management/start' },
                { text: 'Create an account', href: '/facilities-management/sign-up', active: false },
                { text: 'Sign in', href: '/facilities-management/sign-in', active: false }
              ]
            )
          end
        end
      end

      context 'when signed in' do
        let(:controller_name) { 'buyer_details' }
        let(:action_name) { 'edit' }

        before do
          allow(helper).to receive_messages(current_user: current_user_obj, user_signed_in?: true)
        end

        context 'when buyer details are incomplete' do
          before { allow(current_user_obj).to receive(:fm_buyer_details_incomplete?).and_return(true) }

          it 'returns the sign out link' do
            expect(result).to eq(
              [
                { text: 'Sign out', href: '/facilities-management/sign-out', method: :delete }
              ]
            )
          end
        end

        context 'when buyer details are complete' do
          before { allow(current_user_obj).to receive(:fm_buyer_details_incomplete?).and_return(false) }

          it 'returns the My account link' do
            expect(result).to eq(
              [
                { text: 'My account', href: '/facilities-management' },
                { text: 'Sign out', href: '/facilities-management/sign-out', method: :delete }
              ]
            )
          end
        end
      end
    end
  end
  # rubocop:enable RSpec/NestedGroups
end
