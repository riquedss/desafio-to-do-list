# frozen_string_literal: true

ActiveAdmin.register Task do
  permit_params :name, :description, :date, :status, :to_do_list_id, :tag_id

  menu label: 'Tarefas'

  scope :para_fazer
  scope :fazendo
  scope :finalizada
  scope :com_prazo
  scope :atrasada

  filter :name, label: 'Nome'
  filter :status, as: :select, collection: proc { Task.statuses }
  filter :to_do_list, label: 'Lista de tarefas', collection: proc { ToDoList.select(:title, :id).where(user_id: current_user.id) }
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
      item('Atualiza Status', atualiza_status_admin_task_path(resource), class: 'member_link')
    end
  end

  form partial: 'form'

  member_action :atualiza_status, method: :get do
    @task = Task.find(params[:id])
    authorize! :atualiza_status, @task

    render action: 'atualizar_status'
  end

  member_action 'atualizar_status', method: :patch do
    @task = Task.find(params[:id])
    authorize! :atualizar_status, @task

    if @task.update(status: params.require(:task).permit(:status)[:status].try(:to_i))
      flash[:notice] = "Status alterado com sucesso para #{@task.status}"
      redirect_to admin_tasks_path
    else
      render action: 'atualizar_status'
    end
  end
end
