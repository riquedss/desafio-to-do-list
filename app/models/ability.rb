# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Usuario.new

    can :manage, User if user.admin?

    can :read, ActiveAdmin::Page, name: 'Dashboard'
    can :manage, ToDoList, user_id: user.id
    can :manage, Task, to_do_list_id: user.to_do_list_ids
    can :create, Task
  end
end
