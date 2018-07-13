class Post < ApplicationRecord
  belongs_to :user
  belongs_to :album
  default_scope -> { order(created_at: :desc) }
  has_many :post_attachments

  has_many :passive_likes, class_name:  "Like",
                                   foreign_key: "post_id",
                                   dependent: :destroy
  has_many :post_like, through: :passive_likes, source: :user

  has_many :passive_bookmarks, class_name:  "Bookmark",
                                   foreign_key: "post_id",
                                   dependent: :destroy
  has_many :post_bookmark, through: :passive_bookmarks, source: :user

  has_many :post_comments, dependent: :destroy
  accepts_nested_attributes_for :post_comments, allow_destroy: :true

  default_scope -> {order(created_at: :desc)}

  validates :user_id, presence: true

  # VALID_TAG_REGAX = /\^[#]+\+A[a-zA-Z0-9]+\z/m
  # validates :tag, format: { with: VALID_TAG_REGAX }


  scope :search, (lambda do |keyword|
    unless keyword.blank?
      sql_statement = "posts.caption LIKE ? OR posts.tag LIKE ? "
      where(sql_statement, "%#{keyword}%", keyword.to_s)
    end
  end)
end
