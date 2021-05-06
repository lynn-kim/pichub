class Image < ApplicationRecord
  belongs_to :user
  has_one_attached :main_image
  has_and_belongs_to_many :carts
  validates :main_image, presence: true
  validates :discount, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 100}
  validates :price, numericality: {greater_than_or_equal_to: 0}

  def self.public_images(search, current_user_id)
    @public_images = Image.where(private: false).where.not(user_id: current_user_id)
    if search 
      @public_images = @public_images.where('description LIKE ?', "%#{search}%").or(@public_images.where('tags LIKE ?', "%#{search}%"))
    end
    @public_images
  end

  def self.user_images(search, current_user_id)
    @user_images = Image.where(user_id: current_user_id)
    if search
      @user_images = @user_images.where('description LIKE ?', "%#{search}%").or(@user_images.where('tags LIKE ?', "%#{search}%"))
    end
    @user_images
  end

end

