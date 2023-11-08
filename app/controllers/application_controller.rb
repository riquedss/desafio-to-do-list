# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def access_denied(e)
    redirect_to admin_root_path,
                alert: 'Você não tem permissão para realizar esta ação.'
  end

  protected

  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
end
