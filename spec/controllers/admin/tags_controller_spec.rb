require 'rails_helper'

RSpec.describe Admin::TagsController, type: :controller do
  describe 'FLUXO Tag para' do
    let(:user1) { FactoryBot.create(:user, :admin) }
    let(:user2) { FactoryBot.create(:user, :normal) }

    let!(:tag1) { FactoryBot.create(:tag, user: user1) }
    let!(:tag2) { FactoryBot.create(:tag, user: user2) }
    let!(:tag3) { FactoryBot.create(:tag, user: user1) }
    let!(:tag4) { FactoryBot.create(:tag, user: user2) }

    let(:ids_tag_not_user1) { Tag.where.not(user_id: user1.id).ids }
    let(:params_tag) { { name: Faker::Lorem.word } }

    context 'VER suas próprias tags:' do
      it 'GET index' do
        sign_in user1
        get :index, format: :json

        tags_response = JSON.parse(response.body, symbolize_names: true)
        ids_tag_response = tags_response.map { |v| v[:id] }

        resultado_diferenca = ids_tag_response - ids_tag_not_user1

        expect(user1.tag_ids).to match_array(ids_tag_response)
        expect(resultado_diferenca).to match_array(ids_tag_response)
      end
    end

    context 'EDITAR suas próprias tags:' do
      before(:each) do
        sign_in user1
      end

      it 'GET edit Em uma das tags do Usuário DONO' do
        get :edit, params: { id: user1.tag_ids.sample }

        expect(response).to have_http_status(:success)
      end

      it 'GET edit Em uma das tags do Usuário NÃO DONO' do
        get :edit, params: { id: ids_tag_not_user1.sample }

        expect(response).to_not have_http_status(:success)
      end

      it 'PUT update Em uma das tags do Usuário DONO' do
        put :update, params: { id: user1.tag_ids.sample, tag: params_tag }
        expect(response).to redirect_to(admin_tags_path)
      end

      it 'PUT update Em uma das tags do Usuário NÃO DONO' do
        put :update, params: { id: ids_tag_not_user1.sample, tag: params_tag }
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq('Você não tem permissão para realizar esta ação.')
      end
    end

    context 'APAGAR suas próprias tags' do
      before(:each) do
        sign_in user1
      end

      it 'DELETE destroy Em uma das tags do Usuário DONO' do
        delete :destroy, params: { id: user1.tag_ids.sample }
        expect(response).to redirect_to(admin_tags_path)
      end

      it 'DELETE destroy Em uma das tags do Usuário NÃO DONO' do
        delete :destroy, params: { id: ids_tag_not_user1.sample }
        expect(response).to redirect_to(admin_root_path)
        expect(flash[:alert]).to eq('Você não tem permissão para realizar esta ação.')
      end
    end

    context 'CRIAR suas próprias tags:' do
      before(:each) do
        sign_in user1
      end

      it 'GET new' do
        get :new

        expect(response).to have_http_status(:success)
      end

      it 'POST create' do
        post :create, params: { tag: params_tag }, format: :json

        tags_response = JSON.parse(response.body, symbolize_names: true)
        expect(response).to have_http_status(:success)
        expect(tags_response[:user_id]).to eq(user1.id)
      end
    end
  end
end
