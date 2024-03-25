FactoryBot.define do
    factory :friendship do
        user
        association :friend, factory: :user
        status { 'pending' }
    
    
    
       
        trait :accepted do
          status { 'accepted' }
        end
      end
    end