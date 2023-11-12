FactoryBot.define do
  factory :to_do_list do
    user
    title { Faker::Lorem.word }
  end
end
