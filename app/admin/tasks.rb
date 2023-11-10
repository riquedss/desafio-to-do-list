# frozen_string_literal: true

ActiveAdmin.register Task do
  permit_params :name, :description, :date, :status, :to_do_list_id, :tag_id

  menu label: 'Tarefas'

  scope :para_fazer
  scope :fazendo
  scope :finalizada

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

    actions do |resource|
      # byebug
      # item 'Iniciar', "#{atualiza_status_admin_task_path(resource)}?status=1", class: 'member_link'
      # item 'Finalizada', "#{atualiza_status_admin_task_path(resource)}?status=2", class: 'member_link'
    end
  end

  form partial: 'form'

  member_action :atualiza_status, method: :post do
    byebug
  end
end
