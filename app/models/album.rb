class Album < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 140}
  validates :caption, presence: true, length: { maximum: 200}

  scope :get_posts_by_albumid, (lambda do |album_id|
    unless album_id.blank?
      Post.where("album_id = ?", album_id)
    end
  end)

end
