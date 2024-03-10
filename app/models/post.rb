
class Post < ApplicationRecord
  belongs_to :user
  belongs_to :shared_post, class_name: 'Post', optional: true  
  #has_many :reactions, dependent: :destroy
 
  #has_many :shared_posts, class_name: 'Post', foreign_key: 'shared_post_id', dependent: :destroy 
  has_many :comments, as: :commentable
  has_many :likes, as: :likeable
  has_many_attached :images

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

  scope :only_me, ->(user) { where(user: user, privacy_status: PRIVACY_ONLY_ME) }
  scope :friends_only, ->(user) { where(privacy_status: PRIVACY_FRIENDS_ONLY).where('user_id IN (?) OR privacy_status = ?', user.friend_ids, PRIVACY_PUBLIC) }
  scope :public_posts, -> { where(privacy_status: PRIVACY_PUBLIC) }
end
