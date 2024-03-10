class GreetingWorker
    include Sidekiq::Worker
  
    def perform(user_id)
      user = User.find(user_id)
      UserMailer.greeting_email(user).deliver_now
    end
  end