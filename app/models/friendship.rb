class Friendship < ApplicationRecord
  self.table_name = 'friendships'
  
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  validates :user_id, uniqueness: { scope: :friend_id }

  enum status: { pending: 0, accepted: 1, blocked: 2 }

  scope :blocked, -> { where(status: :blocked) }
  scope :accepted, -> { where(status: :accepted) }

  def block
    update(status: :blocked, blocked_at: Time.current)
  end

  def unblock
    update(status: :accepted, blocked_at: nil)
  end

  # ... other model code ...

end
