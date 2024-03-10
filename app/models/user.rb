class User < ApplicationRecord
    has_secure_password
  
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
    validates :phone, numericality: true, allow_blank: true

    has_many :posts
    has_many :comments
    has_many :likes

    has_many :sent_friend_requests, foreign_key: :user_id, class_name: 'Friendship', dependent: :destroy
    has_many :received_friend_requests, foreign_key: :friend_id, class_name: 'Friendship', dependent: :destroy

    has_many :sent_requests, through: :sent_friend_requests, source: :friend
    has_many :received_requests, through: :received_friend_requests, source: :user

    has_many :followers, through: :received_friend_requests, source: :user
    has_many :following, through: :sent_friend_requests, source: :friend

    has_many :friendships, dependent: :destroy


    has_many :blocked_users, dependent: :destroy
    has_many :blocked, through: :blocked_users, source: :blocked_user

    has_one_attached :profile_pic
    has_one_attached :cover_pic


    has_many :posts, dependent: :destroy
    has_many :reactions, dependent: :destroy


    def friends
      friends_from_received = received_requests.where('friendships.status = ?', 'accepted')
      friends_from_sent = sent_requests.where('friendships.status = ?', 'accepted')
  
      friends_from_received + friends_from_sent
    end



    def generate_otp
      self.otp = SecureRandom.hex(3).upcase
      save!
      otp
    end
  
    def verify_otp(entered_otp)
      return false if otp.nil?
  
      entered_otp == otp
    end
  
    def reset_password(new_password)
      update(password: new_password, otp: nil)
    end


  
  end
  
  