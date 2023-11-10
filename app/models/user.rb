# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable, :trackable

  enum role: %i[normal admin]

  has_many :to_do_lists, dependent: :destroy
  has_many :tags, dependent: :destroy

  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  validates_length_of :password, minimum: 8, allow_blank: true, message: 'precisa ter no mínimo 8 caracteres'
  validates_presence_of :role
end
