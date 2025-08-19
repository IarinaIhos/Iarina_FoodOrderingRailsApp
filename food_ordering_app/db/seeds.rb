require 'open-uri'

Product.destroy_all

products = [
  { name: "Chicken Soup", category: "appetizer", diet: "regular", price: 13.00, description: "Entrees", image_url: "https://images.pexels.com/photos/1211887/pexels-photo-1211887.jpeg" },
  { name: "Pasta Carbonara", category: "main_course", diet: "regular", price: 9.00, description: "Second courses", image_url: "https://images.pexels.com/photos/1279330/pexels-photo-1279330.jpeg" },
  { name: "Pasta With Walnut", category: "main_course", diet: "vegetarian", price: 25.00, description: "Second courses", image_url: "https://images.pexels.com/photos/1437267/pexels-photo-1437267.jpeg" },
  { name: "Vitamin Salad", category: "appetizer", diet: "vegan", price: 7.00, description: "Salads", image_url: "https://images.pexels.com/photos/1213710/pexels-photo-1213710.jpeg" },
  { name: "Pizza Margherita", category: "main_course", diet: "vegetarian", price: 12.00, description: "Main dishes", image_url: "https://images.pexels.com/photos/1260968/pexels-photo-1260968.jpeg" },
  { name: "Chocolate Cake", category: "dessert", diet: "regular", price: 6.00, description: "Desserts", image_url: "https://images.pexels.com/photos/291528/pexels-photo-291528.jpeg" },
  { name: "Fruit Smoothie", category: "beverage", diet: "vegan", price: 5.00, description: "Drinks", image_url: "https://images.pexels.com/photos/1095550/pexels-photo-1095550.jpeg" },
  { name: "Grilled Steak", category: "main_course", diet: "regular", price: 18.00, description: "Main dishes", image_url: "https://images.pexels.com/photos/3535383/pexels-photo-3535383.jpeg" }
]

products.each do |product_data|
  begin
    product = Product.new(
      name: product_data[:name],
      category: product_data[:category],
      diet: product_data[:diet],
      price: product_data[:price],
      description: product_data[:description],
      image: URI.parse(product_data[:image_url])
    )

    unless product.image.attached?
      raise "Image attachment failed for #{product_data[:name]}"
    end

    product.save!
    puts "Created product: #{product.name} with image attached: #{product.image.attached?}"
  rescue StandardError => e
    puts "Failed to create #{product_data[:name]}: #{e.message}"
    raise e
  end
end

puts "Total products created: #{Product.count}"
