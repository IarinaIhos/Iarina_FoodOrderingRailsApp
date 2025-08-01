json.extract! admin_product, :id, :name, :category, :diet, :price, :description, :image, :created_at, :updated_at
json.url admin_product_url(admin_product, format: :json)
json.image url_for(admin_product.image)
