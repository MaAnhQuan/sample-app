class Micropost < ApplicationRecord
  belongs_to :user

  scope :order_desc, ->{order created_at: :desc}
  find_feed_item = lambda do |id|
    where "user_id IN (SELECT followed_id FROM relationships
      WHERE follower_id = #{id}) OR user_id = #{id}"
  end
  scope :find_feed_item, find_feed_item

  mount_uploader :picture, PictureUploader

  validates :user, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  private

  def picture_size
    return if picture.size <= Settings.max_pic_size.megabytes
    errors.add :picture, I18n.t("less_than_5")
  end
end
