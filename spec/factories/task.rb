FactoryBot.define do
  factory :task do
    to_do_list
    name { Faker::Lorem.word }
    date { Faker::Time.forward(rand(100)) }

    trait :para_fazer do
      status { 0 }
    end

    trait :fazendo do
      status { 1 }
    end

    trait :finalizada do
      status { 2 }
    end
  end
end
