require 'rails_helper'

RSpec.describe Offer, type: :model do
  let(:catalogue_variant) { create(:catalogue_variant, price: 100.0) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      offer = build(:offer, catalogue_variant: catalogue_variant)
      expect(offer).to be_valid
    end

    it 'is invalid without an offer_name' do
      offer = build(:offer, offer_name: nil, catalogue_variant: catalogue_variant)
      expect(offer).not_to be_valid
      expect(offer.errors[:offer_name]).to include("can't be blank")
    end

    it 'is invalid without a discount' do
      offer = build(:offer, discount: nil, catalogue_variant: catalogue_variant)
      expect(offer).not_to be_valid
      expect(offer.errors[:discount]).to include("can't be blank")
    end

    it 'is invalid with a discount less than or equal to 0' do
      offer = build(:offer, discount: 0, catalogue_variant: catalogue_variant)
      expect(offer).not_to be_valid
      expect(offer.errors[:discount]).to include("must be greater than 0")
    end

    it 'is invalid with a discount greater than 100' do
      offer = build(:offer, discount: 101, catalogue_variant: catalogue_variant)
      expect(offer).not_to be_valid
      expect(offer.errors[:discount]).to include("must be less than or equal to 100")
    end

    it 'is invalid without a start_date' do
      offer = build(:offer, start_date: nil, catalogue_variant: catalogue_variant)
      expect(offer).not_to be_valid
      expect(offer.errors[:start_date]).to include("can't be blank")
    end

    it 'is invalid without an end_date' do
      offer = build(:offer, end_date: nil, catalogue_variant: catalogue_variant)
      expect(offer).not_to be_valid
      expect(offer.errors[:end_date]).to include("can't be blank")
    end
  end

  describe '#discounted_price' do
    it 'calculates the correct discounted price' do
      offer = build(:offer, discount: 20, catalogue_variant: catalogue_variant) # 20% discount on 100
      expect(offer.discounted_price).to eq(80.0)
    end

    it 'returns 0 if no catalogue_variant is associated' do
      offer = build(:offer, catalogue_variant: nil)
      expect(offer.discounted_price).to eq(0)
    end
  end
end
