require 'rails_helper'

RSpec.describe ToDoList, type: :model do
  describe 'Colunas' do
    it { is_expected.to have_db_column(:title).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:string) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
  end
end