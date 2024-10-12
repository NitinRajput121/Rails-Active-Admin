require 'rails_helper'
require 'ostruct'

RSpec.describe PaymentsController, type: :controller do
  let(:user) { create(:user) }
  let(:token) { JWT.encode({ user_id: user.id }, ENV['JWT_SECRET_KEY'], 'HS256') }
  let(:headers) { { 'Token' => "Bearer #{token}" } }
  let!(:cart) { create(:cart, user: user) }
  let!(:catalogue_variant) { create(:catalogue_variant, quantity: 10) }
  let!(:cart_item) { create(:cart_item, cart: cart, catalogue_variant: catalogue_variant, quantity: 2) }
  let(:valid_token) { "Bearer #{token}" }

  before do
    request.headers.merge!(headers) # Add token to the request headers
  end

  describe 'POST #purchase' do
    context 'when the cart has items' do
      it 'creates an order and order items, and updates the stock' do
        # Simulate Stripe successful charge
        allow(Stripe::Customer).to receive(:create).and_return(OpenStruct.new(id: 'cust_12345'))
        allow(Stripe::Charge).to receive(:create).and_return(OpenStruct.new(paid: true))

        post :purchase, params: { email: user.email, token: 'tok_visa' }

        expect(response).to have_http_status(:ok)
        expect(Order.count).to eq(1)
        expect(OrderItem.count).to eq(1)
        expect(OrderItem.first.catalogue_variant_id).to eq(catalogue_variant.id)
        expect(catalogue_variant.reload.quantity).to eq(8) # Stock reduced by cart_item quantity
      end
    end

    context 'when no items in cart' do
      before { cart.cart_items.destroy_all } # Remove all cart items

      it 'returns an error response' do
        post :purchase, params: { email: user.email, token: 'tok_visa' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('No items in cart')
      end
    end

    # context 'when there is insufficient stock' do
    #   before { catalogue_variant.update(quantity: 1) } # Not enough stock for the cart items

    #   it 'returns an error message' do
    #     post :purchase, params: { email: user.email, token: 'tok_visa' }

    #     expect(response).to have_http_status(:unprocessable_entity)
    #     expect(JSON.parse(response.body)['error']).to eq("Insufficient stock for #{catalogue_variant.catalogue.name}")
    #   end
    # end
  end

  describe 'POST #purchase_single_item' do
    context 'when the item is in stock' do
      it 'creates an order, reduces the stock, and returns a successful response' do
        allow(Stripe::Customer).to receive(:create).and_return(OpenStruct.new(id: 'cust_12345'))
        allow(Stripe::Charge).to receive(:create).and_return(OpenStruct.new(paid: true))

        post :purchase_single_item, params: { email: user.email, token: 'tok_visa', variant_id: catalogue_variant.id, quantity: 1 }

        expect(response).to have_http_status(:ok)
        expect(Order.count).to eq(1)
        expect(OrderItem.count).to eq(1)
        expect(OrderItem.first.quantity).to eq(1)
        expect(catalogue_variant.reload.quantity).to eq(9) # Stock reduced by 1
      end
    end

    context 'when the item is out of stock' do
      before { catalogue_variant.update(quantity: 0) }

      it 'returns an error' do
        post :purchase_single_item, params: { email: user.email, token: 'tok_visa', variant_id: catalogue_variant.id, quantity: 1 }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Insufficient stock available')
      end
    end

   context 'when purchasing more than available stock' do
      before { catalogue_variant.update(quantity: 1) } # Set available stock to 1

      it 'returns an error' do
        post :purchase_single_item, params: { email: user.email, token: 'tok_visa', variant_id: catalogue_variant.id, quantity: 2 }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Insufficient stock available')
      end
    end

  context 'when the total amount is invalid' do
      it 'returns an error for invalid total amount' do
        allow(Stripe::Customer).to receive(:create).and_return(OpenStruct.new(id: 'cust_12345'))
        allow(Stripe::Charge).to receive(:create).and_return(OpenStruct.new(paid: true))

        post :purchase_single_item, params: { email: user.email, token: 'tok_visa', variant_id: catalogue_variant.id, quantity: 0 } # Invalid quantity

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Invalid quantity or item not available')
      end
    end

    
  end
end
