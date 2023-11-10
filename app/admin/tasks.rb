# frozen_string_literal: true

ActiveAdmin.register Task do
  permit_params :name, :description, :date, :status, :to_do_list_id, :tag_id

  menu label: 'Tarefas'

  filter :name, label: 'Nome'
  filter :status, as: :select, collection: proc { Task.statuses }
  filter :to_do_list, label: 'Lista de tarefas'
  filter :tag
  filter :date, label: 'Prazo'

  actions :all, except: [:show]

  index do
    column :name
    column :description
    column :status do |resource|
      status_tag(resource.status)
    end
    column :date
    actions
  end

  form partial: 'form'
end
