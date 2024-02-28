# post model
class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable
  has_many :likes, as: :likeable

  validates :content, presence: true

  PRIVACY_ONLY_ME = 'only_me'
  PRIVACY_FRIENDS_ONLY = 'friends_only'
  PRIVACY_PUBLIC = 'public'

  def only_me?
    privacy_status == PRIVACY_ONLY_ME
  end

  def friends_only?
    privacy_status == PRIVACY_FRIENDS_ONLY
  end

  def public?
    privacy_status == PRIVACY_PUBLIC
  end
end

  