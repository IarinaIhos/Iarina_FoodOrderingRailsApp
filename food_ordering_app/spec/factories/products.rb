FactoryBot.define do
    factory :product do
      sequence(:name) { |n| "Product #{n}" }
      description { Faker::Food.description }
      price { rand(5.0..50.0).round(2) }
      category { "main_course" } 
      diet { "regular" }
      
      trait :appetizer do
        category { "appetizer" } 
      end
      
      trait :dessert do
        category { "dessert" }
      end
      
      trait :beverage do
        category { "beverage" }
      end
      
      trait :vegetarian do
        diet { "vegetarian" } 
      end
      
      trait :vegan do
        diet { "vegan" } 
      end
      
      trait :gluten_free do
        diet { "gluten_free" } 
      end
    end
  end
