class Friendship < ApplicationRecord
  self.table_name = 'friendships'
  
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :user_id, uniqueness: { scope: :friend_id }
  validate :can_send_friend_request, on: :create

  private

  def can_send_friend_request
    last_declined_at = Friendship.where(user: user, friend: friend)
                                  .or(Friendship.where(user: friend, friend: user))
                                  .where(status: ['rejected', 'pending']) 
                                  .order(created_at: :desc)
                                  .limit(1)
                                  .pluck(:created_at)
                                  .first
  
    if last_declined_at.present? && last_declined_at > 30.days.ago
      errors.add(:base, "Friend request can only be sent after 30 days from the last declined request.")
    end
  end
  
  
  
end
