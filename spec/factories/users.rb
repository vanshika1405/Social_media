# spec/factories/users.rb

FactoryBot.define do
    factory :user do
      sequence(:email) { |n| "#{n}_#{Faker::Internet.email}" }  
      name { Faker::Name.name }
      password { Faker::Internet.password(min_length: 6) }
      phone { Faker::Number.number(digits: 10) }
    
    end

    
  end
  
  