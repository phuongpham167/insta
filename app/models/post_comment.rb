class PostComment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
end
