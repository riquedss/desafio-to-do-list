# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :to_do_list
  belongs_to :tag
end
