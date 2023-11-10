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
    actions do |resource|
      item 'Tarefas', "#{admin_tasks_path}?q%5Bto_do_list_id_eq%5D=#{resource.id}&commit=Filter", class: 'member_link'
    end
  end

  before_save do |to_do_list|
    to_do_list.user_id = current_user.id
  end

  form partial: 'form'
end
