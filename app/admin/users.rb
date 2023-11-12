# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params do
    params = %i[name last_name birthday email password password_confirmation]

    params << %i[role] if can?(:update_all_params, User)

    params
  end

  menu if: -> { current_user.admin? }, label: 'Usuário'

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  index do
    selectable_column
    id_column
    column :name
    column :last_name
    column :email
    column :role
    column :current_sign_in_at
    column :sign_in_count
    column :created_at

    actions do |usuario|
      link_to 'Alterar Senha', editar_senha_admin_user_path(usuario), class: 'member_link'
    end
  end

  show do
    panel('Detalhes do Usuário') do
      attributes_table_for resource do
        row :name
        row :last_name
        row :email
        row :role
        row :current_sign_in_at
        row :created_at
        row :updated_at
      end
    end
  end

  form partial: 'form'

  action_item :editar_senha, only: :show do
    link_to 'Editar senha', editar_senha_admin_user_path(current_user)
  end

  member_action 'editar_senha' do
    @user = User.find(params[:id])
    authorize! :editar_senha, @user
    render action: 'editar_senha'
  end

  member_action 'atualizar_senha', :method => :patch do
    @user = User.find(params[:id])
    authorize! :atualizar_senha, @user
    if @user.update(params.require(:user).permit(:password, :password_confirmation))
      flash[:notice] = 'Senha alterada com sucesso'
      redirect_to admin_user_path(@user)
    else
      render action: 'editar_senha'
    end
  end
end
