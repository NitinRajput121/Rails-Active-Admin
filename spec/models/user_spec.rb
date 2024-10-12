# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user.name = nil
      expect(user).not_to be_valid
    end

    it 'is not valid without an email' do
      user.email = nil
      expect(user).not_to be_valid
    end

    it 'is not valid with a duplicate email' do
      duplicate_user = build(:user, email: user.email)
      expect(duplicate_user).not_to be_valid
    end

    it 'is not valid without a password_digest' do
      user.password_digest = nil
      expect(user).not_to be_valid
    end

    it 'is not valid with an invalid user_type' do
      user.user_type = 'invalid_type'
      expect(user).not_to be_valid
    end

    it 'is valid with a user_type of seller or customer' do
      user.user_type = 'seller'
      expect(user).to be_valid

      user.user_type = 'customer'
      expect(user).to be_valid
    end
  end

  describe '#subscription_active?' do
    context 'when the user has an active subscription' do
      it 'returns true if the subscription is within the active period' do
        subscription = create(:subscription, user: user, started_at: 1.day.ago, expires_at: 1.day.from_now)
        expect(user.subscription_active?).to be_truthy
      end

      it 'returns false if the subscription has expired' do
        subscription = create(:subscription, user: user, started_at: 2.days.ago, expires_at: 1.day.ago)
        expect(user.subscription_active?).to be_falsey
      end

      it 'returns false if the subscription has not started yet' do
        subscription = create(:subscription, user: user, started_at: 1.day.from_now, expires_at: 2.days.from_now)
        expect(user.subscription_active?).to be_falsey
      end
    end

    context 'when the user has no subscription' do
      it 'returns false' do
        expect(user.subscription_active?).to be_falsey
      end
    end
  end
end

