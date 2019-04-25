require 'rails_helper'

RSpec.describe SupplyTeachers::Admin::Upload, type: :model do
  subject { create(:supply_teachers_admin_upload) }

  describe '#aasm state' do

    describe 'initial state' do
      it { is_expected.to have_state(:in_progress) }
    end

    describe 'in_review' do
      before { subject.review }

      it { is_expected.to have_state(:in_review) }
    end

    describe 'failed' do
      context 'when in_progress' do
        before { subject.fail }

        it { is_expected.to have_state(:failed) }
      end

      context 'when uploading' do
        before do
          subject.aasm.current_state = :uploading
          subject.fail
        end
        it { is_expected.to have_state(:failed) }
      end
    end

    describe 'uploading' do
      before do
        subject.aasm.current_state = :in_review
        subject.upload
      end
      it { is_expected.to have_state(:uploading) }
    end

    describe 'approved' do
      before do
        subject.aasm.current_state = :uploading
        subject.approve
      end
      it { is_expected.to have_state(:approved) }
    end

    describe 'rejected' do
      before do
        subject.aasm.current_state = :in_review
        subject.reject
      end
      it { is_expected.to have_state(:rejected) }
    end

    describe 'canceled' do
      context 'when in review' do
        before do
          subject.aasm.current_state = :in_review
          subject.cancel
        end
        it { is_expected.to have_state(:canceled) }
      end
      context 'when in progress' do
        before do
          subject.aasm.current_state = :in_progress
          subject.cancel
        end
        it { is_expected.to have_state(:canceled) }
      end
    end
  end

  describe '#files_count' do
    context 'when one file' do
      it 'returns 1' do
        expect(subject.files_count).to eq(1)
      end
    end

    context 'when two files' do
      before do
        subject.master_vendor_contacts = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/supplier_lookup_test.csv'))
      end
      it 'returns 2' do
        expect(subject.files_count).to eq(2)
      end
    end
  end

  describe '#previous_uploaded_file_object' do

    context 'when there is a previous approved upload' do
      before do
        subject.aasm.current_state = :uploading
        subject.approve!
      end

      it 'returns previous approved object with uploaded file' do
        expect(described_class.previous_uploaded_file_object(:supplier_lookup)).to eq subject
      end

      it 'returns nil if file is not there' do
        expect(described_class.previous_uploaded_file_object(:master_vendor_contacts)).to eq nil
      end
    end

    context 'when there is no previous upload that is approved' do
      it 'returns nil' do
        expect(described_class.previous_uploaded_file_object(:supplier_lookup)).to eq nil
      end
    end
  end

  describe '#cleanup_input_files' do

  end

  describe '#default scope' do

  end

end
