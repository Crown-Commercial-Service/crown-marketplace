require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET nominated_worker_question' do
    it 'renders template' do
      get :nominated_worker_question
      expect(response).to render_template('nominated_worker_question')
    end
  end

  describe 'GET nominated_worker_answer' do
    before do
      get :nominated_worker_answer, params: { nominated_worker: nominated_worker }
    end

    context 'when nominated worker is yes' do
      let(:nominated_worker) { 'yes' }

      it 'redirects to non nominated worker outcome' do
        expect(response).to redirect_to(
          school_postcode_question_path(nominated_worker: 'yes')
        )
      end
    end

    context 'when nominated worker is no' do
      let(:nominated_worker) { 'no' }

      it 'redirects to non nominated worker outcome' do
        expect(response).to redirect_to(
          non_nominated_worker_outcome_path(nominated_worker: 'no')
        )
      end
    end

    context 'when nominated worker is blank' do
      let(:nominated_worker) { '' }

      it 'redirects to nominated worker question' do
        expect(response).to redirect_to(nominated_worker_question_path)
      end

      it 'sets a flash error message' do
        expect(flash[:error]).to eq 'Please choose an option'
      end
    end
  end

  describe 'GET school_postcode_question' do
    it 'renders template' do
      get :school_postcode_question
      expect(response).to render_template('school_postcode_question')
    end
  end

  describe 'GET school_postcode_answer' do
    let(:postcode) { Faker::Address.unique.postcode }

    it 'redirects to branches with postcode and nominated_worker' do
      get :school_postcode_answer, params: {
        postcode: postcode,
        nominated_worker: 'yes'
      }
      expect(response).to redirect_to(
        branches_path(
          postcode: postcode,
          nominated_worker: 'yes'
        )
      )
    end
  end

  describe 'GET non_nominated_worker_outcome' do
    it 'renders template' do
      get :non_nominated_worker_outcome
      expect(response).to render_template('non_nominated_worker_outcome')
    end
  end
end
