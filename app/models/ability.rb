# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Usuario.new

    can :read, ActiveAdmin::Page, name: 'Dashboard'
    can :manage, ToDoList, user_id: user.id
    can :manage, Tag, user_id: user.id
    can :manage, Task, to_do_list_id: user.to_do_list_ids
    can :new, Task

    if user.admin?
      can :manage, User
    else
      can %i[read edit update destroy editar_senha atualizar_senha], User, id: user.id
    end
  end
end
