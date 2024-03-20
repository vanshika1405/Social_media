# spec/factories/likes.rb

FactoryBot.define do
    factory :like do
      # Define any attributes for the like model here
      association :user
      association :likeable, factory: :post # Assuming you have a Post factory
    end
  end
  