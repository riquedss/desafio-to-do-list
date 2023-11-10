# frozen_string_literal: true

class Tag < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :nullify

  validates :name, presence: true

  scope :ativas, -> { where(ativo: true) }
end
