require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Colunas' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:birthday).of_type(:date) }
    it { is_expected.to have_db_column(:last_name).of_type(:string) }
    it { is_expected.to have_db_column(:email).of_type(:string).with_options(default: '', null: false) }
    it { is_expected.to have_db_column(:role).of_type(:integer) }
  end

  describe 'Validações do modelo' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
    it { is_expected.to validate_presence_of(:password) }
  end
end
