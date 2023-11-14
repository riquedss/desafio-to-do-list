# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :to_do_list
  belongs_to :tag, optional: true

  enum status: %i[para_fazer fazendo finalizada]

  validates :name, presence: true

  scope :para_fazer, -> { where(status: 0) }
  scope :fazendo, -> { where(status: 1) }
  scope :finalizada, -> { where(status: 2) }
  scope :com_prazo, -> { where.not(date: nil) }
  scope :atrasada, -> { where('date < ? and status != 2 ', DateTime.now) }

  def de_hoje?
    date&.today?
  end

  def da_semana?
    date && date >= DateTime.now.beginning_of_week && date <= DateTime.now.end_of_week
  end
end
