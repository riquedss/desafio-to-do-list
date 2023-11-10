# frozen_string_literal: true

ActiveAdmin.register Task do
  permit_params :name, :description, :date, :to_do_list_id

  menu label: 'Tarefas'

  actions :all, except: [:show]

  index do
    column :name
    column :description
    column :date
    actions
  end

  form partial: 'form'
end
