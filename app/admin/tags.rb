# frozen_string_literal: true

ActiveAdmin.register Tag do
  permit_params :name, :ativo

  menu label: 'Tags'

  filter :name, label: 'Nome'

  scope :ativas
  scope :all

  actions :all, except: [:show]

  index do
    column :name
    column :ativo
    column :created_at
    column :updated_at
    actions
  end

  before_save do |tag|
    tag.user_id = current_user.id
  end

  form partial: 'form'
end
