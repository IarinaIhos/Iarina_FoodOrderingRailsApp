require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      user = User.new
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end

    it 'validates presence of email' do
      user = User.new
      user.valid?
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'validates presence of password' do
      user = User.new
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'has many cart_items' do
      user = create(:user)
      expect(user.cart_items).to be_empty
    end

    it 'has many orders' do
      user = create(:user)
      expect(user.orders).to be_empty
    end

    it 'has many access_grants' do
      user = create(:user)
      expect(user.access_grants).to be_empty
    end

    it 'has many access_tokens' do
      user = create(:user)
      expect(user.access_tokens).to be_empty
    end
  end

  describe 'enums' do
    it 'defines role enum' do
      user = create(:user)
      expect(user.user?).to be true
      expect(user.admin?).to be false
      
      user.admin!
      expect(user.admin?).to be true
      expect(user.user?).to be false
    end
  end

  describe 'factory' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end

    it 'has a valid admin factory' do
      expect(build(:user, :admin)).to be_valid
    end
  end
end
