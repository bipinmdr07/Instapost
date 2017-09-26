class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  validates :text, :user_id, :post_id, presence: true
  delegate  :name, to: :user, prefix: true
end
