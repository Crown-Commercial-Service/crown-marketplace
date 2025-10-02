require 'rails_helper'

RSpec.describe DataLoader do
  let(:manage_task) { described_class.new(**attributes) }

  let(:application) { 'fm' }
  let(:task_name) { 'bank_holidays' }

  let(:attributes) do
    {
      application:,
      task_name:,
    }
  end

  describe 'validations' do
    it 'is valid' do
      expect(manage_task).to be_valid
    end

    context 'when application is blank' do
      let(:application) { '' }

      it 'is invalid and has the correct errors' do
        expect(manage_task).not_to be_valid

        expect(manage_task.errors[:application].first).to eq('You must select the application the task needs to run in')
        expect(manage_task.errors[:task_name]).to be_none
      end
    end

    context 'when application is not in the list' do
      let(:application) { 'something else' }

      it 'is invalid and has the correct errors' do
        expect(manage_task).not_to be_valid

        expect(manage_task.errors[:application].first).to eq('You must select the application the task needs to run in')
        expect(manage_task.errors[:task_name]).to be_none
      end
    end

    context 'when task_name is blank' do
      let(:task_name) { '' }

      it 'is invalid and has the correct errors' do
        expect(manage_task).not_to be_valid

        expect(manage_task.errors[:application]).to be_none
        expect(manage_task.errors[:task_name].first).to eq('You must select the task you want to run')
      end
    end

    context 'when task_name is not in the list' do
      let(:task_name) { 'something else' }

      it 'is invalid and has the correct errors' do
        expect(manage_task).not_to be_valid

        expect(manage_task.errors[:application]).to be_none
        expect(manage_task.errors[:task_name].first).to eq('You must select the task you want to run')
      end
    end
  end

  describe 'invoke_task' do
    let(:result) { manage_task.invoke_task }

    before do
      allow(DataLoader::BankHolidays).to receive(:update_bank_holidays_csv)
      allow(DataLoader::Frameworks).to receive(:update_frameworks)
      allow(DataLoader::TestData).to receive(:import_test_data)

      manage_task.invoke_task
    end

    context 'when the task_name is bank_holidays' do
      it 'calls the bank holiday task' do
        expect(DataLoader::BankHolidays).to have_received(:update_bank_holidays_csv)
      end
    end

    context 'when the task_name is update_frameworks' do
      let(:task_name) { 'update_frameworks' }

      it 'calls the framework task' do
        expect(DataLoader::Frameworks).to have_received(:update_frameworks)
      end
    end

    context 'when the task_name is import_test_data' do
      let(:task_name) { 'import_test_data' }

      it 'calls the test data task' do
        expect(DataLoader::TestData).to have_received(:import_test_data)
      end
    end
  end
end
