require 'rails_helper'

RSpec.describe Api::AccountsController, type: :controller do
  let!(:account) { Account.create(name: 'Test Account', balance: 1000) }
  let!(:account_2) { Account.create(name: 'Second Account', balance: 500) }

  before do
    allow(controller).to receive(:http_authenticate).and_return(true)
  end

  describe 'GET #show' do
    context 'when the account exists' do
      it 'returns the account details' do
        get :show, params: { id: account.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['id']).to eq(account.id)
      end
    end

    context 'when the account does not exist' do
      it 'returns a not found error' do
        get :show, params: { id: 999 }
        expect(response).to have_http_status(:not_found)
        p response.body
        expect(JSON.parse(response.body)['error']).to eq('Account not found')
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new account' do
        post :create, params: { account: { name: 'New Account', balance: 200 } }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['name']).to eq('New Account')
      end
    end

    context 'with invalid parameters' do
      it 'returns an error' do
        post :create, params: { account: { name: nil, balance: -100 } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq("Name can't be blank")
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the account' do
        patch :update, params: { id: account.id, account: { name: 'Updated Account', balance: 1500 } }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['name']).to eq('Updated Account')
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the account' do
      expect {
        delete :destroy, params: { id: account.id }
      }.to change(Account, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST #deposit' do
    context 'with valid parameters' do
      it 'deposits money into the account' do
        post :deposit, params: { id: account.id, amount: 500 }
        p response.body
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['balance']).to eq(1500)
      end
    end

    context 'with invalid parameters' do
      it 'returns an error' do
        post :deposit, params: { id: account.id, amount: -500 }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Amount must be greater than 0')
      end
    end
  end

  describe 'POST #withdraw' do
    context 'with valid parameters' do
      it 'withdraws money from the account' do
        post :withdraw, params: { id: account.id, amount: 500 }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['balance']).to eq(500)
      end
    end

    context 'with insufficient balance' do
      it 'returns an error' do
        post :withdraw, params: { id: account.id, amount: 2000 }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Insufficient balance')
      end
    end
  end

  describe 'POST #transfer' do
    context 'with valid parameters' do
      it 'transfers money between accounts' do
        post :transfer, params: { id: account.id, to_account_id: account_2.id, amount: 300 }
        expect(response).to have_http_status(:ok)
        response_body = JSON.parse(response.body)
        expect(response_body['from_balance']).to eq(700)
        expect(response_body['to_balance']).to eq(800)
      end
    end

    context 'with invalid parameters' do
      it 'returns an error if source account has insufficient balance' do
        post :transfer, params: { id: account.id, to_account_id: account_2.id, amount: 2000 }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Insufficient balance in source account')
      end
    end
  end
end
