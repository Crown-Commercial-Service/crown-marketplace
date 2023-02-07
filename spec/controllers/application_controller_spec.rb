require 'rails_helper'

RSpec.describe ApplicationController do
  describe '.service_path_base' do
    before do
      controller.params[:service] = service if service
      controller.params[:framework] = framework if framework
    end

    let(:result) { controller.send(:service_path_base) }
    let(:service) { nil }
    let(:framework) { nil }

    context 'when the service is nil' do
      context 'when the framework is nil' do
        it 'returns /facilities-management/RM6232' do
          expect(result).to eq '/facilities-management/RM6232'
        end
      end

      context 'when the framework is present' do
        let(:framework) { 'RM007' }

        it 'returns /facilities-management/RM007' do
          expect(result).to eq '/facilities-management/RM007'
        end
      end
    end

    context 'when the service is facilities management' do
      let(:service) { 'facilities_management' }

      context 'when the framework is nil' do
        it 'returns /facilities-management/RM6232' do
          expect(result).to eq '/facilities-management/RM6232'
        end
      end

      context 'when the framework is present' do
        let(:framework) { 'RM3830' }

        it 'returns /facilities-management/RM3830' do
          expect(result).to eq '/facilities-management/RM3830'
        end
      end
    end

    context 'when the service is facilities management admin' do
      let(:service) { 'facilities_management/admin' }

      context 'when the framework is nil' do
        it 'returns /facilities-management/RM6232/admin' do
          expect(result).to eq '/facilities-management/RM6232/admin'
        end
      end

      context 'when the framework is present' do
        let(:framework) { 'RM3830' }

        it 'returns /facilities-management/RM3830/admin' do
          expect(result).to eq '/facilities-management/RM3830/admin'
        end
      end
    end

    context 'when the service is facilities management supplier' do
      let(:service) { 'facilities_management/supplier' }

      context 'when the framework is nil' do
        it 'returns /facilities-management/RM6232/supplier' do
          expect(result).to eq '/facilities-management/RM6232/supplier'
        end
      end

      context 'when the framework is present' do
        let(:framework) { 'RM3830' }

        it 'returns /facilities-management/RM3830/supplier' do
          expect(result).to eq '/facilities-management/RM3830/supplier'
        end
      end
    end

    context 'when the service is crown marketplace' do
      let(:service) { 'crown_marketplace' }

      context 'when the framework is nil' do
        it 'returns /crown_marketplace' do
          expect(result).to eq '/crown-marketplace'
        end
      end

      context 'when the framework is present' do
        let(:framework) { 'RM3830' }

        it 'returns /crown_marketplace' do
          expect(result).to eq '/crown-marketplace'
        end
      end
    end
  end
end
