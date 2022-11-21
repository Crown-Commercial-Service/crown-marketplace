require 'rails_helper'

RSpec.describe Cognito::SignUpUser do
  describe '#call' do
    let(:email) { 'user@crowncommercial.gov.uk' }
    let(:password) { 'ValidPass123!' }
    let(:password_confirmation) { 'ValidPass123!' }
    let(:roles) { %i[buyer st_access] }
    let(:email_list) { ['crowncommercial.gov.uk', 'email.com', 'tmail.com', 'kmail.com', 'cmail.com', 'jmail.com', 'cheemail.com'] }
    let(:allow_list_file) { Tempfile.new('allow_list.txt') }

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

    describe '#validations' do
      let(:response) { described_class.new(email, password, password_confirmation, roles) }

      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:sign_up).and_return(JSON[{ user_sub: '12345'.to_json }])
        allow(aws_client).to receive(:admin_add_user_to_group).and_return(JSON[{ user_sub: '12345'.to_json }])
      end

      context 'when password shorter than 8 characters' do
        let(:password) { 'Pass1!' }
        let(:password_confirmation) { 'Pass1!' }

        it 'is invalid and it has the correct error message' do
          expect(response.valid?).to eq false
          expect(response.errors[:password].first).to eq 'Password must be 8 characters or more'
        end
      end

      context 'when password does not contain at least one uppercase letter' do
        let(:password) { 'password1!' }
        let(:password_confirmation) { 'password1!' }

        it 'is invalid and it has the correct error message' do
          expect(response.valid?).to eq false
          expect(response.errors[:password].first).to eq 'Password must include a capital letter'
        end
      end

      context 'when password does not contain at least one symbol' do
        let(:password) { 'Password123' }
        let(:password_confirmation) { 'Password123' }

        it 'is invalid and it has the correct error message' do
          expect(response.valid?).to eq false
          expect(response.errors[:password].first).to eq 'Password must include a special character'
        end
      end

      context 'when password does not contain at least one number' do
        let(:password) { 'Password!' }
        let(:password_confirmation) { 'Password!' }

        it 'is invalid and it has the correct error message' do
          expect(response.valid?).to eq false
          expect(response.errors[:password].first).to eq 'Password must include a number'
        end
      end

      context 'when password is nil' do
        let(:password) { '' }
        let(:password_confirmation) { 'ValidPass123!' }

        it 'is invalid and it has the correct error message' do
          expect(response.valid?).to eq false
          expect(response.errors[:password].first).to eq 'Enter a password'
        end
      end

      context 'when password and password confirmation do not match' do
        let(:password) { 'SomeOtherPass123!' }
        let(:password_confirmation) { 'ValidPass123!' }

        it 'is invalid and it has the correct error message' do
          expect(response.valid?).to eq false
          expect(response.errors[:password_confirmation].first).to eq "Passwords don't match"
        end
      end

      context 'when email is nil' do
        let(:email) { '' }

        it 'is invalid and it has the correct error message' do
          expect(response.valid?).to eq false
          expect(response.errors[:email].first).to eq 'Enter an email address in the correct format, like name@example.com'
        end
      end

      context 'when email contains an uppercase character' do
        let(:email) { 'uSer@cheemail.com' }

        it 'is invalid and it has the correct error message' do
          expect(response.valid?).to eq false
          expect(response.errors[:email].first).to eq 'Email address cannot contain any capital letters'
        end
      end

      context 'when email domain contains an uppercase character' do
        let(:email) { 'user@Cheemail.com' }

        it 'is invalid and it has the correct error message' do
          expect(response.valid?).to eq false
          expect(response.errors[:email].first).to eq 'Email address cannot contain any capital letters'
          expect(response.errors.of_kind?(:email, :not_on_safelist)).to be false
        end
      end

      context 'when email domain not in safelist' do
        let(:email) { 'user@test.com' }

        it 'is invalid and it has the correct error message' do
          expect(response.valid?).to eq false
          expect(response.errors[:email].first).to eq 'You must use a public sector email'
        end
      end

      context 'when email domain is in safelist' do
        let(:email) { 'user@cheemail.com' }

        it 'is invalid' do
          expect(response.valid?).to eq true
        end
      end

      context 'when local is present but domain is not' do
        let(:email) { 'local@' }

        it 'is invalid and gives the correct error message' do
          expect(response.valid?).to eq false
          expect(response.errors[:email].first).to eq 'Enter an email address in the correct format, like name@example.com'
        end
      end

      context 'when domain is present but local is not' do
        let(:email) { '@domain.com' }

        it 'is invalid and gives the correct error message' do
          expect(response.valid?).to eq false
          expect(response.errors[:email].first).to eq 'Enter an email address in the correct format, like name@example.com'
        end
      end

      context 'when neither local or domain are present' do
        let(:email) { '@' }

        it 'is invalid and gives the correct error message' do
          expect(response.valid?).to eq false
          expect(response.errors[:email].first).to eq 'Enter an email address in the correct format, like name@example.com'
        end
      end

      context 'and domain and local are present, but there are two @ symbols' do
        let(:email) { 'dom@@ain.com' }

        it 'is invalid and gives the correct error message' do
          expect(response.valid?).to eq false
          expect(response.errors[:email].first).to eq 'Enter an email address in the correct format, like name@example.com'
        end
      end

      context 'and there is an extra @ symbol in the domain' do
        let(:email) { 'local@domain@com' }

        it 'is invalid and gives the correct error message' do
          expect(response.valid?).to eq false
          expect(response.errors[:email].first).to eq 'Enter an email address in the correct format, like name@example.com'
        end
      end

      context 'and it is a valid email' do
        let(:email) { 'user@crowncommercial.gov.uk' }

        it 'is valid' do
          expect(response.valid?).to eq true
        end
      end
    end

    context 'when success' do
      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:sign_up).and_return(JSON[{ user_sub: '12345'.to_json }])
        allow(aws_client).to receive(:admin_add_user_to_group).and_return(JSON[{ user_sub: '12345'.to_json }])
      end

      it 'creates user' do
        expect { described_class.call(email, password, password_confirmation, roles) }.to change(User, :count).by 1
      end

      it 'returns the newly created resource' do
        response = described_class.call(email, password, password_confirmation, roles)
        expect(response.user).to eq User.order(created_at: :asc).last
      end

      it 'returns success' do
        response = described_class.call(email, password, password_confirmation, roles)
        expect(response.success?).to eq true
      end

      it 'returns no error' do
        response = described_class.call(email, password, password_confirmation, roles)
        expect(response.error).to eq nil
      end
    end

    context 'when cognito error' do
      let(:response) { described_class.call(email, password, password_confirmation, roles) }

      before do
        allow(Aws::CognitoIdentityProvider::Client).to receive(:new).and_return(aws_client)
        allow(aws_client).to receive(:sign_up).and_raise(error.new('Some context', 'Some message'))
      end

      context 'and the error is ServiceError' do
        let(:error) { Aws::CognitoIdentityProvider::Errors::ServiceError }

        it 'does not create user' do
          expect { response }.not_to change(User, :count)
        end

        it 'does not return user' do
          expect(response.user).to eq nil
        end

        it 'does not return success' do
          expect(response.success?).to eq false
        end

        it 'returns an error' do
          expect(response.errors.empty?).to eq false
        end
      end

      context 'and the error is UsernameExistsException' do
        let(:error) { Aws::CognitoIdentityProvider::Errors::UsernameExistsException }

        it 'does not create user' do
          expect { response }.not_to change(User, :count)
        end

        it 'does not return user' do
          expect(response.user).to eq nil
        end

        it 'does return success' do
          expect(response.success?).to eq true
        end

        it 'returns no error' do
          expect(response.error).to eq nil
        end
      end
    end
  end
end
