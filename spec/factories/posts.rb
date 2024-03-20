# spec/factories/posts.rb

FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    # Replace 'image.jpeg' with the actual name of your image file
    images { [Rails.root.join('spec', 'fixtures', 'image.jpeg').open] }
    association :user 
  end
end
