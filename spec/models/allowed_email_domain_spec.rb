require 'rails_helper'

RSpec.describe AllowedEmailDomain do
  let(:allowed_email_domain) { described_class.new(email_domain: email_domain) }
  let(:email_list) { ['cheemail.com', 'cmail.com', 'crowncommercial.gov.uk', 'email.com', 'jmail.com', 'kmail.com', 'tmail.com'] }
  let(:allow_list_file) { Tempfile.new('allow_list.txt') }

  before do
    allow_list_file.write(email_list.join("\n"))
    allow_list_file.close
    allow(allowed_email_domain).to receive(:allow_list_file_path).and_return(allow_list_file.path)
  end

  after do
    allow_list_file.unlink
  end

  describe 'validations' do
    context 'when the email is blank' do
      let(:email_domain) { '' }

      it 'is not valid and has the correct error message' do
        expect(allowed_email_domain.valid?).to be false
        expect(allowed_email_domain.errors[:email_domain].first).to eq 'Enter an email domain'
      end
    end

    context 'when the email has invalid characters' do
      let(:email_domain) { 'exa mple@hello. com' }

      it 'is not valid and has the correct error message' do
        expect(allowed_email_domain.valid?).to be false
        expect(allowed_email_domain.errors[:email_domain].first).to eq 'The email domain can only contain letters, numbers, hyphens or full stops'
      end
    end

    context 'when the email domain is already on the allow list' do
      let(:email_domain) { 'crowncommercial.gov.uk' }

      it 'is not valid and has the correct error message' do
        expect(allowed_email_domain.valid?).to be false
        expect(allowed_email_domain.errors[:email_domain].first).to eq 'The email domain is already in the Allow list'
      end
    end

    context 'when the email domain has excess space' do
      let(:email_domain) { '  dfe.gov.uk  ' }

      it 'removes the excess space' do
        allowed_email_domain.valid?
        expect(allowed_email_domain.email_domain).to eq 'dfe.gov.uk'
      end
    end

    context 'when the email domain has capital letters' do
      let(:email_domain) { 'Dfe.gOv.uK  ' }

      it 'downcases the capital letters' do
        allowed_email_domain.valid?
        expect(allowed_email_domain.email_domain).to eq 'dfe.gov.uk'
      end
    end

    context 'when the email domain meets the requirements' do
      let(:email_domain) { 'dfe-gov.uk' }

      it 'is valid' do
        expect(allowed_email_domain.valid?).to be true
      end
    end
  end

  describe 'save' do
    context 'when the email domain is invalid' do
      let(:email_domain) { '' }

      it 'returns false' do
        expect(allowed_email_domain.save).to be false
      end
    end

    context 'when the email domain is valid' do
      let(:email_domain) { 'dfe.gov.uk' }

      it 'returns true' do
        expect(allowed_email_domain.save).to be true
      end

      it 'updates the allow list' do
        allowed_email_domain.save
        expect(allowed_email_domain.allow_list).to eq ['cheemail.com', 'cmail.com', 'crowncommercial.gov.uk', 'dfe.gov.uk', 'email.com', 'jmail.com', 'kmail.com', 'tmail.com']
      end
    end
  end

  describe 'search_allow_list' do
    context 'when the email domain is empty' do
      let(:email_domain) { '' }

      it 'returns all the email domains' do
        expect(allowed_email_domain.search_allow_list).to eq email_list
      end
    end

    context 'when there is a partial email domain' do
      let(:email_domain) { 'email' }

      it 'returns some of the email domains' do
        expect(allowed_email_domain.search_allow_list).to eq ['cheemail.com', 'email.com']
      end
    end
  end

  describe 'remove_email_domain' do
    before { allowed_email_domain.remove_email_domain }

    context 'when a domain in the allow list is given' do
      let(:email_domain) { 'jmail.com' }

      it 'is removed from the allow list' do
        expect(allowed_email_domain.allow_list).to eq ['cheemail.com', 'cmail.com', 'crowncommercial.gov.uk', 'email.com', 'kmail.com', 'tmail.com']
      end
    end

    context 'when an email domain that is not in the list is given' do
      let(:email_domain) { 'mail' }

      it 'does not change the allow list' do
        expect(allowed_email_domain.allow_list).to eq email_list
      end
    end
  end
end
