require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  describe 'FLUXO Users para User COMUM ->' do
    let(:user1) { FactoryBot.create(:user, :normal) }

    let!(:user2) { FactoryBot.create(:user) }
    let!(:user3) { FactoryBot.create(:user) }
    let!(:user4) { FactoryBot.create(:user) }
    let!(:user5) { FactoryBot.create(:user) }

    let(:ids_user_not_current) { User.select(:id).where.not(id: user1.id) }

    let(:param_password) { Faker::Alphanumeric.alpha(10) }
    let(:params_user) {
      {
        name: Faker::Name.first_name,
        email: Faker::Internet.email,
        password: param_password,
        password_confirmation: param_password
      }
    }

    context 'VER lista de USERS do sistema:' do
      it 'GET index' do
        sign_in user1
        get :index, format: :json

        users_response = JSON.parse(response.body, symbolize_names: true)
        id_user_response = users_response.map { |v| v[:id] }

        expect([user1.id]).to match_array(id_user_response)
      end
    end

    context 'EDITAR USERS do sistema::' do
      before(:each) do
        sign_in user1
      end

      it 'GET edit No USER CORRENTE' do
        get :edit, params: { id: user1.id }

        expect(response).to have_http_status(:success)
      end

      it 'GET edit Em outro USER' do
        get :edit, params: { id: ids_user_not_current.sample }

        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq('Você não tem permissão para realizar esta ação.')
      end

      it 'PUT update No USER CORRENTE' do
        put :update, params: { id: user1.id, user: params_user }

        expect(response).to redirect_to(admin_user_path(user1))
      end

      it 'PUT update Em outro USER' do
        put :update, params: { id: ids_user_not_current.sample, user: params_user }
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq('Você não tem permissão para realizar esta ação.')
      end

      it 'PUT update Na Role do USER CORRENTE' do
        put :update, params: { id: user1, user: { role: :admin } }, format: :json

        expect(User.find(user1.id).admin?).to be false
      end

      it 'GET editar_senha No USER CORRENTE' do
        get :editar_senha, params: { id: user1.id }

        expect(response).to have_http_status(:success)
      end

      it 'GET editar_senha Em outro USER' do
        get :editar_senha, params: { id: ids_user_not_current.sample }

        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq('Você não tem permissão para realizar esta ação.')
      end

      it 'PUT atualizar_senha No USER CORRENTE' do
        put :atualizar_senha, params: { id: user1.id, user: params_user }

        expect(response).to redirect_to(admin_user_path(user1))
      end

      it 'PUT atualizar_senha Em outro USER' do
        put :atualizar_senha, params: { id: ids_user_not_current.sample, user: params_user }

        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq('Você não tem permissão para realizar esta ação.')
      end
    end

    context 'APAGAR lista de USERS do sistema:' do
      before(:each) do
        sign_in user1
      end

      it 'DELETE destroy No USER CORRENTE' do
        delete :destroy, params: { id: user1.id }
        expect(response).to redirect_to(admin_users_path)
      end

      it 'DELETE destroy Em outro USER' do
        delete :destroy, params: { id: ids_user_not_current.sample }
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq('Você não tem permissão para realizar esta ação.')
      end
    end

    context 'CRIAR lista de USERS do sistema::' do
      before(:each) do
        sign_in user1
      end

      it 'GET new' do
        get :new

        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq('Você não tem permissão para realizar esta ação.')
      end

      it 'POST create' do
        post :create, params: { user: params_user }, format: :json

        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq('Você não tem permissão para realizar esta ação.')
      end
    end
  end

  describe 'FLUXO Users para User ADMIN ->' do
    let(:user1) { FactoryBot.create(:user, :admin) }

    let!(:user2) { FactoryBot.create(:user) }
    let!(:user3) { FactoryBot.create(:user) }
    let!(:user4) { FactoryBot.create(:user) }
    let!(:user5) { FactoryBot.create(:user) }

    let(:ids_user_not_current) { User.select(:id).where.not(id: user1.id) }

    let(:param_password) { Faker::Alphanumeric.alpha(10) }
    let(:params_user) {
      {
        name: Faker::Name.first_name,
        email: Faker::Internet.email,
        password: param_password,
        password_confirmation: param_password
      }
    }

    context 'VER lista de USERS do sistema:' do
      it 'GET index' do
        sign_in user1
        get :index, format: :json

        users_response = JSON.parse(response.body, symbolize_names: true)
        id_user_response = users_response.map { |v| v[:id] }

        expect(User.select(:id).ids).to match_array(id_user_response)
      end
    end

    context 'EDITAR USERS do sistema::' do
      before(:each) do
        sign_in user1
      end

      it 'GET edit No USER CORRENTE' do
        get :edit, params: { id: user1.id }

        expect(response).to have_http_status(:success)
      end

      it 'GET edit Em outro USER' do
        get :edit, params: { id: ids_user_not_current.sample }

        expect(response).to have_http_status(:success)
      end

      it 'PUT update No USER CORRENTE' do
        put :update, params: { id: user1.id, user: params_user }

        expect(response).to redirect_to(admin_user_path(user1))
      end

      it 'PUT update Em outro USER' do
        put :update, params: { id: user3.id, user: params_user }

        expect(response).to redirect_to(admin_user_path(user3))
      end

      it 'PUT update Na Role do USER CORRENTE' do
        put :update, params: { id: user1, user: { role: :admin } }, format: :json

        expect(User.find(user1.id).admin?).to be true
      end

      it 'GET editar_senha No USER CORRENTE' do
        get :editar_senha, params: { id: user1.id }

        expect(response).to have_http_status(:success)
      end

      it 'GET editar_senha Em outro USER' do
        get :editar_senha, params: { id: ids_user_not_current.sample }

        expect(response).to have_http_status(:success)
      end

      it 'PUT atualizar_senha No USER CORRENTE' do
        put :atualizar_senha, params: { id: user1.id, user: params_user }

        expect(response).to redirect_to(admin_user_path(user1))
      end

      it 'PUT atualizar_senha Em outro USER' do
        put :atualizar_senha, params: { id: user3, user: params_user }

        expect(response).to redirect_to(admin_user_path(user3))
      end
    end

    context 'APAGAR lista de USERS do sistema:' do
      before(:each) do
        sign_in user1
      end

      it 'DELETE destroy No USER CORRENTE' do
        delete :destroy, params: { id: user1.id }
        expect(response).to redirect_to(admin_users_path)
      end

      it 'DELETE destroy Em outro USER' do
        delete :destroy, params: { id: user3.id }
        expect(response).to redirect_to(admin_users_path)
      end
    end

    context 'CRIAR lista de USERS do sistema::' do
      before(:each) do
        sign_in user1
      end

      it 'GET new' do
        get :new

        expect(response).to have_http_status(:success)
      end

      it 'POST create' do
        post :create, params: { user: params_user }, format: :json

        expect(response).to have_http_status(:success)
      end
    end
  end
end
