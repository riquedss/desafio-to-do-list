# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable, :trackable

  enum role: %i[normal admin]

  has_many :to_do_lists, dependent: :destroy
  has_many :tags, dependent: :destroy
end
