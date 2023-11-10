# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Usuario.new

    can :read, ActiveAdmin::Page, name: 'Dashboard'
    can :manage, ToDoList, user_id: user.id
    can :manage, Tag, user_id: user.id
    can :manage, User, id: user.id
    can :manage, Task, to_do_list_id: user.to_do_list_ids
    can :create, Task

    if user.admin?
      can :manage, User
    else
      cannot %i[new create index delete], User
    end
  end
end
