require 'rails_helper'

RSpec.describe Admin::ToDoListsController, type: :controller do
  describe 'FLUXO To Do List para' do
    let(:user1) { FactoryBot.create(:user, :admin) }
    let(:user2) { FactoryBot.create(:user, :normal) }

    let!(:to_do_list1) { FactoryBot.create(:to_do_list, user: user1) }
    let!(:to_do_list2) { FactoryBot.create(:to_do_list, user: user2) }
    let!(:to_do_list3) { FactoryBot.create(:to_do_list, user: user1) }
    let!(:to_do_list4) { FactoryBot.create(:to_do_list, user: user2) }

    let(:ids_list_not_user1) { ToDoList.where.not(user_id: user1.id).ids }
    let(:params_to_do_list) { { title: Faker::Lorem.word } }

    context 'VER suas próprias listas:' do
      it 'GET index' do
        sign_in user1
        get :index, format: :json

        to_do_lists_response = JSON.parse(response.body, symbolize_names: true)
        ids_to_do_list_response = to_do_lists_response.map { |v| v[:id] }

        resultado_diferenca = ids_to_do_list_response - ids_list_not_user1

        expect(user1.to_do_list_ids).to match_array(ids_to_do_list_response)
        expect(resultado_diferenca).to match_array(ids_to_do_list_response)
      end
    end

    context 'EDITAR suas próprias listas:' do
      before(:each) do
        sign_in user1
      end

      it 'GET edit Em uma das lista do Usuário DONO' do
        get :edit, params: { id: user1.to_do_list_ids.sample }

        expect(response).to have_http_status(:success)
      end

      it 'GET edit Em uma das lista do Usuário NÃO DONO' do
        get :edit, params: { id: ids_list_not_user1.sample }

        expect(response).to_not have_http_status(:success)
      end

      it 'PUT update Em uma das lista do Usuário DONO' do
        put :update, params: { id: user1.to_do_list_ids.sample, to_do_list: params_to_do_list }
        expect(response).to redirect_to(admin_to_do_lists_path)
      end

      it 'PUT update Em uma das lista do Usuário NÃO DONO' do
        put :update, params: { id: ids_list_not_user1.sample, to_do_list: params_to_do_list }
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq('Você não tem permissão para realizar esta ação.')
      end
    end

    context 'APAGAR suas próprias listas' do
      before(:each) do
        sign_in user1
      end

      it 'DELETE destroy Em uma das lista do Usuário DONO' do
        delete :destroy, params: { id: user1.to_do_list_ids.sample }
        expect(response).to redirect_to(admin_to_do_lists_path)
      end

      it 'DELETE destroy Em uma das lista do Usuário NÃO DONO' do
        delete :destroy, params: { id: ids_list_not_user1.sample }
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq('Você não tem permissão para realizar esta ação.')
      end
    end

    context 'CRIAR suas próprias listas:' do
      before(:each) do
        sign_in user1
      end

      it 'GET new' do
        get :new

        expect(response).to have_http_status(:success)
      end

      it 'POST create' do
        post :create, params: { to_do_list: params_to_do_list }, format: :json

        to_do_lists_response = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
        expect(to_do_lists_response[:user_id]).to eq(user1.id)
      end
    end
  end
end
