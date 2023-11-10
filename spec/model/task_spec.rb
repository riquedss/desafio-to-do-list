require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'Colunas' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:description).of_type(:string) }
    it { is_expected.to have_db_column(:to_do_list_id).of_type(:integer) }
    it { is_expected.to have_db_column(:tag_id).of_type(:integer) }
    it { is_expected.to have_db_column(:status).of_type(:integer) }
  end
end