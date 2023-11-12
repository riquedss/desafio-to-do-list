FactoryBot.define do
  factory :tag do
    user
    name { Faker::Lorem.word }
    ativo { false }

    trait :ativo do
      ativo { true }
    end
  end
end
