require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'Colunas' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:ativo).of_type(:boolean) }
    it { is_expected.to have_db_column(:user_id).of_type(:integer) }
  end

  describe 'Validações do modelo' do
    it { is_expected.to validate_presence_of(:name) }
  end
end
