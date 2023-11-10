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
        render turbo_stream: turbo_stream.append('turbo-frame', partial: 'sucesso')
      else
        render turbo_stream: turbo_stream.append('turbo-frame', partial: 'erro')
      end
    end

    private

    def params_signup
      params.require(:user).permit(:name, :last_name, :email, :birthday, :password, :password_confirmation)
    end
  end
end
