# frozen_string_literal: true

module Auth
  class SignupController < ApplicationController
    def new
      @user ||= User.new
      render :new
    end

    def create
      @user = User.new(params_signup)

      if @user.save
        @user = User.new
        redirect_to new_user_session_path
        flash[:notice] = 'Usuário cadastrado com sucesso!'
      else
        render turbo_stream: turbo_stream.append('turbo-frame-erro', partial: 'erro_flash')
      end
    end

    private

    def params_signup
      params.require(:user).permit(:name, :last_name, :email, :birthday, :password, :password_confirmation)
    end
  end
end
