class User < ApplicationRecord
  has_many :posts, dependent: :destroy
  has_many :albums, dependent: :destroy
  attr_accessor :remember_token
  before_save :downcase_email

  has_many :active_likes, class_name:  "Like",
                                  foreign_key: "user_id",
                                  dependent: :destroy
  has_many :user_like, through: :active_likes, source: :post
  has_many :active_relationships, class_name:  "Relationship",
    foreign_key: "follower_id", dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
    foreign_key: "followed_id", dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :post_comments, dependent: :destroy

  has_many :active_bookmarks, class_name:  "Bookmark",
                                  foreign_key: "user_id",
                                  dependent:   :destroy
  has_many :user_bookmark, through: :active_bookmarks, source: :post

  has_many :notifications, dependent: :destroy

  validates :name, presence: true, length: { maximum: Settings.user.name.max_lenght}
  VALID_EMAIL_REGAX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: Settings.user.email.max_lenght}, format: { with: VALID_EMAIL_REGAX }, uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: Settings.user.password.min_lenght }

  def User.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def feed
    Post.where("user_id IN (?) OR user_id = ?", following_ids, id)
  end

  def listnoti
    Notification.where("user_id = ?", id).order("created_at desc")
  end

  def album_list
    Album.where("user_id = ?", id)
  end
  #like a post
  def like post_id
    user_like << post_id
  end

  #unlike a post
  def unlike post_id
    user_like.delete(post_id)
  end

  #return if current user is like the post
  def like? post_id
    user_like.include?(post_id)
  end

  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  #bookmark a post
  def bookmark post_id
    user_bookmark << post_id
  end

  #unbookmark a post
  def unbookmark post_id
    user_bookmark.delete(post_id)
  end

  #return if current user is mark the post
  def bookmark? post_id
    user_bookmark.include?(post_id)
  end

  scope :find_user_follow, (lambda do |keyword|
    User.where("users.name LIKE ?", keyword)
  end)

  private
    def downcase_email
      self.email = email.downcase
    end
end
