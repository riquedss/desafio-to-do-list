# frozen_string_literal: true

ActiveAdmin.register ToDoList do
  permit_params :title, :description

  actions :all, except: [:show]

  index do
    column :title
    column :description
    actions
  end

  form partial: 'form'

  before_save do |to_do_list|
    to_do_list.user_id = current_user.id
  end

  form partial: 'form'
end
