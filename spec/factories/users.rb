FactoryBot.define do
  factory :user do
    name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    birthday { Faker::Date.birthday(10) }
    password { Faker::Alphanumeric.alpha(10) }

    trait :admin do
      role { 1 }
    end

    trait :normal do
      role { 0 }
    end
  end
end
