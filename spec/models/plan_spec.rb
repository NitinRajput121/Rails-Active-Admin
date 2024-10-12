require 'rails_helper'

RSpec.describe Plan, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes for a paid plan' do
      plan = build(:plan, plan_type: 'paid', price_monthly: 100.0, discount: 10.0, discount_type: 'Percentage', discount_percentage: 20)
      expect(plan).to be_valid
    end

    it 'is valid with valid attributes for a free plan' do
      plan = build(:plan, plan_type: 'free')
      expect(plan).to be_valid
    end

    it 'is invalid without price_monthly for a paid plan' do
      plan = build(:plan, plan_type: 'paid', price_monthly: nil)
      expect(plan).not_to be_valid
      expect(plan.errors[:price_monthly]).to include("can't be blank")
    end

    it 'is invalid without discount, discount_type, or discount_percentage for a paid plan' do
      plan = build(:plan, plan_type: 'paid', discount: nil, discount_type: nil, discount_percentage: nil)
      expect(plan).not_to be_valid
      expect(plan.errors[:discount]).to include("can't be blank")
      expect(plan.errors[:discount_type]).to include("can't be blank")
      expect(plan.errors[:discount_percentage]).to include("can't be blank")
    end

    it 'is valid without price_monthly, discount, discount_type, or discount_percentage for a free plan' do
      plan = build(:plan, plan_type: 'free', price_monthly: nil, discount: nil, discount_type: nil, discount_percentage: nil)
      expect(plan).to be_valid
    end

    it 'is invalid without a name' do
      plan = build(:plan, name: nil)
      expect(plan).not_to be_valid
      expect(plan.errors[:name]).to include("can't be blank")
    end
  end

  describe '#discounted_price_monthly' do
    it 'returns the original monthly price if there is no discount' do
      plan = build(:plan, price_monthly: 100.0, discount: nil, discount_percentage: nil)
      expect(plan.discounted_price_monthly).to eq(100.0)
    end

    it 'calculates the discounted monthly price with a percentage discount' do
      plan = build(:plan, price_monthly: 100.0, discount_type: 'Percentage', discount_percentage: 20)
      expect(plan.discounted_price_monthly).to eq(80.0)
    end

    it 'calculates the discounted monthly price with a fixed discount' do
      plan = build(:plan, price_monthly: 100.0, discount_type: 'Fixed', discount_percentage: 20)
      expect(plan.discounted_price_monthly).to eq(80.0)
    end
  end

  describe '#discounted_price_yearly' do
    it 'returns the original yearly price if there is no discount' do
      plan = build(:plan, price_yearly: 1000.0, discount: nil, discount_percentage: nil)
      expect(plan.discounted_price_yearly).to eq(1000.0)
    end

    it 'calculates the discounted yearly price with a percentage discount' do
      plan = build(:plan, price_yearly: 1000.0, discount_type: 'Percentage', discount_percentage: 20)
      expect(plan.discounted_price_yearly).to eq(800.0)
    end

    it 'calculates the discounted yearly price with a fixed discount' do
      plan = build(:plan, price_yearly: 1000.0, discount_type: 'Fixed', discount_percentage: 200)
      expect(plan.discounted_price_yearly).to eq(800.0)
    end
  end
end
