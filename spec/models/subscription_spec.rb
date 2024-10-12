# spec/models/subscription_spec.rb
require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:plan) { create(:plan) }
  let(:user) { create(:user) }
  let(:subscription) { create(:subscription, plan: plan, user: user) }

  context 'associations' do
    it { should belong_to(:plan) }
    it { should belong_to(:user) }
  end

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(subscription).to be_valid
    end

    it 'is invalid without a plan' do
      subscription.plan = nil
      expect(subscription).not_to be_valid
      expect(subscription.errors[:plan]).to include("must exist")
    end

    it 'is invalid without a user' do
      subscription.user = nil
      expect(subscription).not_to be_valid
      expect(subscription.errors[:user]).to include("must exist")
    end

    it 'is invalid without a started_at' do
      subscription.started_at = nil
      expect(subscription).not_to be_valid
    end

    it 'is invalid without an expires_at' do
      subscription.expires_at = nil
      expect(subscription).not_to be_valid
    end
  end

  describe '#expired?' do
    it 'returns true if the subscription has expired' do
      expired_subscription = create(:subscription, expires_at: 1.day.ago)
      expect(expired_subscription.expired?).to be true
    end

    it 'returns false if the subscription is still active' do
      active_subscription = create(:subscription, expires_at: 1.day.from_now)
      expect(active_subscription.expired?).to be false
    end
  end
end
