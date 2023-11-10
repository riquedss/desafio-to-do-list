# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :email, :role, :password, :password_confirmation

  menu label: 'Usuário'

  index do
    selectable_column
    id_column
    column :email
    column :role
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
      f.input :role, collection: User.roles.keys
    end
    f.actions
  end
end
