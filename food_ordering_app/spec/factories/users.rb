FactoryBot.define do
    factory :user do
      sequence(:email) { |n| "user#{n}@example.com" }
      password { "password123" }
      password_confirmation { "password123" }
      name { Faker::Name.name }
      role { "user" }
      
      trait :admin do
        role { "admin" }
      end
      
      trait :invalid do
        email { nil }
        password { nil }
        name { nil }
      end
    end
  end
