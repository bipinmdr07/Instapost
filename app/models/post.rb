class Post < ActiveRecord::Base
  belongs_to :user
  mount_uploader :photo, PhotoUploader

  validates :photo, :description, :user_id, presence: true
end
