# frozen_string_literal: true

ActiveAdmin.register ToDoList do
  permit_params :title, :description

  menu label: 'Lista de Tarefas'

  filter :title, label: 'Título'

  actions :all, except: [:show]

  index do
    column :title
    column :description
    column :created_at
    column :updated_at
    actions
  end

  before_save do |to_do_list|
    to_do_list.user_id = current_user.id
  end

  form partial: 'form'
end
