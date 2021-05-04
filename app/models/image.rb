class Image < ApplicationRecord
  belongs_to :user
  has_one_attached :main_image
  validates :main_image, presence: true
end

