require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :request do
  describe 'GET /api/v1/products' do

    let!(:pizza) { create(:product, name: 'Margherita Pizza', price: 15.0, category: 'main_course') }
    let!(:salad) { create(:product, name: 'Caesar Salad', price: 8.0, category: 'appetizer') }
    let!(:cake) { create(:product, name: 'Chocolate Cake', price: 12.0, category: 'dessert') }

    context 'when no filters are applied' do
      it 'returns all products' do
        get '/api/v1/products'

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)

        expect(json_response.length).to eq(3)
        
        product_names = json_response.map { |p| p['name'] }
        expect(product_names).to include('Margherita Pizza')
        expect(product_names).to include('Caesar Salad')
        expect(product_names).to include('Chocolate Cake')
      end
    end

    context 'when filtering by category' do
      it 'returns only products in specified category' do
        get '/api/v1/products', params: { category: 'appetizer' }
        
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)

        expect(json_response.length).to eq(1)
        expect(json_response.first['name']).to eq('Caesar Salad')
  
        expect(salad.reload.category).to eq('appetizer')
      end

      it 'returns empty array for non-existent category' do
        get '/api/v1/products', params: { category: 'non_existent' }
        
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to be_empty
      end
    end

    context 'when filtering by price range' do
      it 'returns products within price range' do
        get '/api/v1/products', params: { min_price: 10.0, max_price: 20.0 }
        
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
      
        expect(json_response.length).to eq(2)
        
        product_names = json_response.map { |p| p['name'] }
        expect(product_names).to include('Margherita Pizza')
        expect(product_names).to include('Chocolate Cake')
        expect(product_names).not_to include('Caesar Salad') 
      end

      it 'returns empty array when no products match price range' do
        get '/api/v1/products', params: { min_price: 100.0, max_price: 200.0 }
        
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
        expect(json_response).to be_empty
      end
    end

    context 'when combining multiple filters' do
      it 'applies all filters correctly' do
        expensive_pizza = create(:product, name: 'Expensive Pizza', price: 25.0, category: 'main_course')
        
        get '/api/v1/products', params: { 
          category: 'main_course', 
          min_price: 20.0, 
          max_price: 30.0 
        }
        
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)

        expect(json_response.length).to eq(1)
        expect(json_response.first['name']).to eq('Expensive Pizza')
      end
    end
  end

  describe 'GET /api/v1/products/:id' do
    let(:product) { create(:product, name: 'Test Product', price: 20.0) }

    context 'when product exists' do
      it 'returns the specific product' do
        get "/api/v1/products/#{product.id}"
        
        expect(response).to have_http_status(:ok)
        
        json_response = JSON.parse(response.body)
      
        expect(json_response['id']).to eq(product.id)
        expect(json_response['name']).to eq('Test Product')
        expect(json_response['price']).to eq('20.0') 
        expect(json_response['description']).to eq(product.description)
      end
    end

    context 'when product does not exist' do
      it 'returns 404 error' do
        get '/api/v1/products/999999'
        
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when invalid ID is provided' do
      it 'returns 404 error' do
        get '/api/v1/products/invalid_id'
        
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
