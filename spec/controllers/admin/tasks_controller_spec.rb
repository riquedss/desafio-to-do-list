require 'rails_helper'

RSpec.describe Admin::TasksController, type: :controller do
  describe 'FLUXO To Do List para' do
    let(:user1) { FactoryBot.create(:user, :admin) }
    let(:user2) { FactoryBot.create(:user, :normal) }

    let(:to_do_list1) { FactoryBot.create(:to_do_list, user: user1) }
    let(:to_do_list2) { FactoryBot.create(:to_do_list, user: user2) }

    let(:ids_list_not_user1) { ToDoList.where.not(user_id: user1.id).ids }

    let!(:task1) { FactoryBot.create(:task, to_do_list: to_do_list1) }
    let!(:task2) { FactoryBot.create(:task, to_do_list: to_do_list1) }
    let!(:task3) { FactoryBot.create(:task, to_do_list: to_do_list2) }
    let!(:task4) { FactoryBot.create(:task, to_do_list: to_do_list2) }

    let(:ids_tasks_to_do_list_from_user1) { Task.select(:id).where(to_do_list_id: user1.to_do_list_ids).ids }
    let(:ids_tasks_to_do_list_not_from_user1) { Task.select(:id).where.not(to_do_list_id: user1.to_do_list_ids).ids }

    let(:params_task) { { name: Faker::Lorem.word } }
    let(:params_task_status) { { status: 1 } }

    let(:params_task_list_from_user) { { name: Faker::Lorem.word, to_do_list_id: user1.to_do_list_ids.sample } }
    let(:params_task_list_not_from_user) { { name: Faker::Lorem.word, to_do_list_id: ids_list_not_user1.sample } }

    context 'VER suas próprias tarefas:' do
      it 'GET index' do
        sign_in user1
        get :index, format: :json

        tasks_response = JSON.parse(response.body, symbolize_names: true)
        ids_tasks_response = tasks_response.map { |v| v[:id] }
        ids_to_do_list_tasks_response = tasks_response.map { |v| v[:to_do_list_id] }

        resultado_diferenca = ids_to_do_list_tasks_response - user1.to_do_list_ids

        expect(ids_tasks_to_do_list_from_user1).to match_array(ids_tasks_response)
        expect(resultado_diferenca).to match_array([])
      end
    end

    context 'EDITAR suas próprias tarefas:' do
      before(:each) do
        sign_in user1
      end

      it 'GET edit Em uma das lista do Usuário DONO' do
        get :edit, params: { id: ids_tasks_to_do_list_from_user1.sample }

        expect(response).to have_http_status(:success)
      end

      it 'GET edit Em uma das lista do Usuário NÃO DONO' do
        get :edit, params: { id: ids_tasks_to_do_list_not_from_user1.sample }

        expect(response).to_not have_http_status(:success)
      end

      it 'PUT update Em uma das lista do Usuário DONO' do
        put :update, params: { id: ids_tasks_to_do_list_from_user1.sample, task: params_task }
        expect(response).to redirect_to(admin_tasks_path)
      end

      it 'PUT update Em uma das lista do Usuário NÃO DONO' do
        put :update, params: { id: ids_tasks_to_do_list_not_from_user1.sample, task: params_task }
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq('Você não tem permissão para realizar esta ação.')
      end

      it 'ATUALIZA STATUS Em uma das lista do Usuário DONO' do
        get :atualiza_status, params: { id: ids_tasks_to_do_list_from_user1.sample }
        expect(response).to have_http_status(:success)
      end

      it 'ATUALIZA STATUS Em uma das lista do Usuário NÃO DONO' do
        get :atualiza_status, params: { id: ids_tasks_to_do_list_not_from_user1.sample }
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq('Você não tem permissão para realizar esta ação.')
      end

      it 'ATUALIZAR STATUS Em uma das lista do Usuário DONO' do
        put :atualizar_status, params: { id: ids_tasks_to_do_list_from_user1.sample, task: params_task_status }
        expect(response).to redirect_to(admin_tasks_path)
      end

      it 'ATUALIZAR STATUS Em uma das lista do Usuário NÃO DONO' do
        put :atualizar_status, params: { id: ids_tasks_to_do_list_not_from_user1.sample, task: params_task_status }
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq('Você não tem permissão para realizar esta ação.')
      end
    end

    context 'APAGAR suas próprias tarefas' do
      before(:each) do
        sign_in user1
      end

      it 'DELETE destroy Em uma das lista do Usuário DONO' do
        delete :destroy, params: { id: ids_tasks_to_do_list_from_user1.sample }
        expect(response).to redirect_to(admin_tasks_path)
      end

      it 'DELETE destroy Em uma das lista do Usuário NÃO DONO' do
        delete :destroy, params: { id: ids_tasks_to_do_list_not_from_user1.sample }
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq('Você não tem permissão para realizar esta ação.')
      end
    end

    context 'CRIAR suas próprias tarefas:' do
      before(:each) do
        sign_in user1
      end

      it 'GET new' do
        get :new

        expect(response).to have_http_status(:success)
      end

      it 'POST create Associando uma tarefa da lista do usuário' do
        post :create, params: { task: params_task_list_from_user }, format: :json

        expect(response).to have_http_status(:success)
      end

      it 'POST create Associando uma tarefa da lista de outro usuário' do
        post :create, params: { task: params_task_list_not_from_user }, format: :json

        expect(response).to_not have_http_status(:success)
      end
    end
  end
end
