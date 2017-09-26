class Post < ActiveRecord::Base
  belongs_to :user
  has_many :comments, dependent: :destroy
  mount_uploader :photo, PhotoUploader

  validates :photo, :description, :user_id, presence: true
  acts_as_votable

  delegate :photo, :name, to: :user, prefix: true
end
