require 'rails_helper'

RSpec.describe SupplyTeachers::Admin::Upload, type: :model do
  subject { create(:supply_teachers_admin_upload) }

  describe '#default scope' do
    it 'orders by descending created_at' do
      expect(described_class.all.to_sql).to eq described_class.all.order(created_at: :desc).to_sql
    end
  end

  describe '#aasm state' do
    before do
      allow(subject).to receive(:cleanup_input_files)
      allow(subject).to receive(:start_upload)
    end
    describe 'initial state' do
      it { is_expected.to have_state(:in_progress) }
      it { is_expected.not_to have_received(:cleanup_input_files) }
      it { is_expected.not_to have_received(:start_upload) }
    end

    describe 'in_review' do
      before { subject.review }

      it { is_expected.to have_state(:in_review) }
      it { is_expected.not_to have_received(:cleanup_input_files) }
      it { is_expected.not_to have_received(:start_upload) }
    end

    describe 'failed' do
      context 'when in_progress' do
        before { subject.fail }

        it { is_expected.to have_state(:failed) }
        it { is_expected.to have_received(:cleanup_input_files) }
        it { is_expected.not_to have_received(:start_upload) }
      end

      context 'when uploading' do
        before do
          subject.aasm.current_state = :uploading
          subject.fail
        end
        it { is_expected.to have_state(:failed) }
        it { is_expected.to have_received(:cleanup_input_files) }
        it { is_expected.not_to have_received(:start_upload) }
      end
    end

    describe 'uploading' do
      before do
        subject.aasm.current_state = :in_review
        subject.upload
      end
      it { is_expected.to have_state(:uploading) }
      it { is_expected.not_to have_received(:cleanup_input_files) }
      it { is_expected.to have_received(:start_upload) }
    end

    describe 'approved' do
      before do
        subject.aasm.current_state = :uploading
        subject.approve
      end
      it { is_expected.to have_state(:approved) }
      it { is_expected.not_to have_received(:cleanup_input_files) }
      it { is_expected.not_to have_received(:start_upload) }
    end

    describe 'rejected' do
      before do
        subject.aasm.current_state = :in_review
        subject.reject
      end
      it { is_expected.to have_state(:rejected) }
      it { is_expected.to have_received(:cleanup_input_files) }
      it { is_expected.not_to have_received(:start_upload) }
    end

    describe 'canceled' do
      context 'when in review' do
        before do
          subject.aasm.current_state = :in_review
          subject.cancel
        end
        it { is_expected.to have_state(:canceled) }
        it { is_expected.to have_received(:cleanup_input_files) }
        it { is_expected.not_to have_received(:start_upload) }
      end
      context 'when in progress' do
        before do
          subject.aasm.current_state = :in_progress
          subject.cancel
        end
        it { is_expected.to have_state(:canceled) }
        it { is_expected.to have_received(:cleanup_input_files) }
        it { is_expected.not_to have_received(:start_upload) }
      end
    end
  end

  describe '#available_for_cp' do
    let(:upload) { create(:supply_teachers_admin_upload) }

    context 'when no previous upload exists' do
      it 'returns true for supplier_lookup' do
        expect(upload.send(:available_for_cp, :supplier_lookup)).to eq false
      end
    end

    context 'when previous approved upload exists' do
      before do
        subject.aasm.current_state = :uploading
        subject.approve!
      end

      it 'returns true for supplier_lookup' do
        expect(upload.send(:available_for_cp, :supplier_lookup)).to eq true
      end

      it 'returns false for current_accredited_suppliers' do
        expect(upload.send(:available_for_cp, :current_accredited_suppliers)).to eq false
      end

      it 'returns false for geographical_data_all_suppliers' do
        expect(upload.send(:available_for_cp, :geographical_data_all_suppliers)).to eq false
      end

      it 'returns false for lot_1_and_lot_2_comparisons' do
        expect(upload.send(:available_for_cp, :lot_1_and_lot_2_comparisons)).to eq false
      end

      it 'returns false for master_vendor_contacts' do
        expect(upload.send(:available_for_cp, :master_vendor_contacts)).to eq false
      end

      it 'returns false for neutral_vendor_contacts' do
        expect(upload.send(:available_for_cp, :neutral_vendor_contacts)).to eq false
      end

      it 'returns false for pricing_for_tool' do
        expect(upload.send(:available_for_cp, :pricing_for_tool)).to eq false
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

end
