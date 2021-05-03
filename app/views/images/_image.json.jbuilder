json.extract! image, :id, :description, :user_id, :price, :discount, :tags, :private, :created_at, :updated_at
json.url image_url(image, format: :json)
