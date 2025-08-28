# Food Ordering App

A full-stack food ordering application built with Ruby on Rails, featuring both web interface and RESTful API endpoints for admin and user management.

## Features

### User Features
- **User Authentication**: Secure user registration and login with Devise
- **Product Browsing**: View available food items with categories and dietary options
- **Shopping Cart**: Add, update, and remove items from cart
- **Order Management**: Create orders from cart items and view order history
- **Responsive Design**: Modern UI with Bootstrap styling

### Admin Features
- **Product Management**: Create, read, update, and delete products
- **User Management**: View, update, and delete user accounts
- **Order Management**: View all orders, update order status, and delete orders
- **Admin Dashboard**: Comprehensive admin interface

### API Features
- **RESTful API**: Complete API endpoints for all functionality
- **OAuth2 Authentication**: Secure API access with Doorkeeper
- **Role-based Access**: Separate endpoints for users and admins
- **JSON Responses**: Consistent API response format

## Tech Stack

- **Backend**: Ruby on Rails 8.0
- **Database**: SQLite (development), PostgreSQL (production)
- **Authentication**: Devise + Doorkeeper (OAuth2)
- **Frontend**: ERB templates with Bootstrap
- **File Storage**: Active Storage
- **API**: RESTful JSON API

## Installation

### Prerequisites
- Ruby 3.1+
- Rails 8.0+
- Node.js 18+
- SQLite3

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd food_ordering_app
   ```

2. **Install dependencies**
   ```bash
   bundle install
   npm install
   ```

3. **Setup database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Start the server**
   ```bash
   rails server
   ```

5. **Access the application**
   - Web Interface: http://localhost:3000
   - API Base URL: http://localhost:3000/api/v1

## API Documentation

### Authentication

All API endpoints require authentication using OAuth2 access tokens.

**Get Access Token:**
```bash
POST /oauth/token
Content-Type: application/json

{
  "grant_type": "password",
  "email": "user@example.com",
  "password": "password"
}
```

### User API Endpoints

#### Products
- `GET /api/v1/products` - List all products
- `GET /api/v1/products/:id` - Get specific product

#### Cart Management
- `GET /api/v1/carts` - View cart
- `POST /api/v1/carts` - Add item to cart
- `PUT /api/v1/carts/:id` - Update item quantity
- `DELETE /api/v1/carts/:id` - Remove item from cart
- `DELETE /api/v1/carts/clear` - Clear entire cart

#### Orders
- `GET /api/v1/orders` - View user's orders
- `GET /api/v1/orders/:id` - View specific order
- `POST /api/v1/orders` - Create order from cart

### Admin API Endpoints

#### User Management
- `GET /api/v1/admin/users` - List all users
- `GET /api/v1/admin/users/:id` - Get specific user
- `PUT /api/v1/admin/users/:id` - Update user
- `DELETE /api/v1/admin/users/:id` - Delete user

#### Product Management
- `GET /api/v1/admin/products` - List all products
- `GET /api/v1/admin/products/:id` - Get specific product
- `POST /api/v1/admin/products` - Create product
- `PUT /api/v1/admin/products/:id` - Update product
- `DELETE /api/v1/admin/products/:id` - Delete product

#### Order Management
- `GET /api/v1/admin/orders` - List all orders
- `GET /api/v1/admin/orders/:id` - Get specific order
- `PUT /api/v1/admin/orders/:id` - Update order
- `DELETE /api/v1/admin/orders/:id` - Delete order

## API Examples

### Add Item to Cart
```bash
curl -X POST http://localhost:3000/api/v1/carts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -d '{
    "product_id": 1,
    "quantity": 2
  }'
```

### Create Product (Admin)
```bash
curl -X POST http://localhost:3000/api/v1/admin/products \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ADMIN_ACCESS_TOKEN" \
  -d '{
    "product": {
      "name": "Margherita Pizza",
      "category": "main_course",
      "diet": "vegetarian",
      "price": 12.99,
      "description": "Classic pizza with tomato sauce, mozzarella cheese, and fresh basil"
    }
  }'
```

### Create Order
```bash
curl -X POST http://localhost:3000/api/v1/orders \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

## Database Schema

### Users
- `id` - Primary key
- `email` - User email (unique)
- `name` - User name
- `role` - User role (0: user, 1: admin)
- `encrypted_password` - Encrypted password
- `created_at`, `updated_at` - Timestamps

### Products
- `id` - Primary key
- `name` - Product name
- `category` - Product category (enum: appetizer, main_course, dessert, beverage)
- `diet` - Dietary option (enum: regular, vegetarian, vegan, gluten_free)
- `price` - Product price
- `description` - Product description
- `image` - Product image (Active Storage)
- `created_at`, `updated_at` - Timestamps

### Orders
- `id` - Primary key
- `user_id` - Foreign key to users
- `total_amount` - Order total
- `status` - Order status
- `created_at`, `updated_at` - Timestamps

### Order Items
- `id` - Primary key
- `order_id` - Foreign key to orders
- `product_id` - Foreign key to products
- `quantity` - Item quantity
- `price` - Item price at time of order
- `created_at`, `updated_at` - Timestamps

### Cart Items
- `id` - Primary key
- `user_id` - Foreign key to users
- `product_id` - Foreign key to products
- `quantity` - Item quantity
- `created_at`, `updated_at` - Timestamps

## User Roles

### Regular User
- Browse products
- Manage cart
- Create and view orders
- Cannot access admin functionality

### Admin
- All user capabilities
- Manage products (CRUD)
- Manage users (view, update, delete)
- Manage all orders
- Cannot access cart functionality

## Security Features

- **OAuth2 Authentication**: Secure API access
- **Role-based Authorization**: Different access levels for users and admins
- **Input Validation**: Server-side validation for all inputs
- **CSRF Protection**: Built-in Rails CSRF protection
- **SQL Injection Protection**: ActiveRecord ORM protection

## Development

### Running Tests
```bash
rails test
```

### Code Quality
```bash
bundle exec rubocop
```

### Database Console
```bash
rails dbconsole
```

## Deployment

### Environment Variables
- `RAILS_ENV` - Environment (development, production)
- `DATABASE_URL` - Database connection string
- `SECRET_KEY_BASE` - Rails secret key

### Production Setup
1. Set environment variables
2. Run database migrations
3. Precompile assets
4. Start the server

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support, please open an issue in the repository or contact the development team.

---

**Note**: This application is designed for educational and development purposes. For production use, additional security measures and optimizations may be required.
