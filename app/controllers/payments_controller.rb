
class PaymentsController < ApplicationController
  before_action :find_cart_items, only: [:purchase]
  before_action :find_single_item, only: [:purchase_single_item]

  def purchase
    return render json: { error: 'No items in cart' }, status: :unprocessable_entity unless @cart_items.present?

    total_amount = calculate_total(@cart_items)

    customer = create_stripe_customer(params[:email], params[:token])
    charge = create_stripe_charge(customer.id, total_amount, 'Purchase of cart items')

    if charge.paid
      create_order_from_cart(@cart_items, total_amount)
      render json: { message: 'Payment successful', charge: charge }, status: :ok
    else
      render json: { error: 'Payment failed' }, status: :unprocessable_entity
    end
  rescue Stripe::CardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end



  def purchase_single_item
    # total_amount = apply_subscription_discount(@variant_price * @quantity_to_purchase)

    customer = create_stripe_customer(params[:email], params[:token])
    charge = create_stripe_charge(customer.id, total_amount, "Purchase of #{@variant.catalogue.name}")

    if charge.paid
      @variant.update(quantity: @variant.quantity - @quantity_to_purchase)

      order = create_order(@variant, total_amount, @quantity_to_purchase)
      render json: { message: 'Payment successful', order: order }, status: :ok
    else
      render json: { error: 'Payment failed' }, status: :unprocessable_entity
    end
  rescue Stripe::CardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end



  private

  def find_cart_items
    @cart = Cart.find_by(user_id: @current_user.id)
    @cart_items = @cart ? @cart.cart_items : []
  end

  def find_single_item
    @variant = CatalogueVariant.find_by(id: params[:variant_id])
    @quantity_to_purchase = params[:quantity].to_i
    if @variant.nil? || @variant.quantity < @quantity_to_purchase
      return render json: { error: 'Insufficient stock available' }, status: :unprocessable_entity
    end
    @variant_price = apply_subscription_discount(@variant.discounted_price || @variant.price)
  end

  def calculate_total(cart_items)
    total_amount = 0
    cart_items.each do |item|
      variant = CatalogueVariant.find(item.catalogue_variant_id)
    if variant.quantity < item.quantity
      return render json: { error: "Insufficient stock for #{variant.catalogue.name}" }, status: :unprocessable_entity
    end

      price_to_use = apply_subscription_discount(variant.discounted_price || variant.price)
      total_amount += price_to_use * item.quantity
    end
    total_amount
  end


  def apply_subscription_discount(price)
   if @current_user.subscription_active?
    # Apply 5% discount if user has an active subscription
    price -= (price * 0.05)
   end
       price
 end

  def create_order_from_cart(cart_items, total_amount)
    order = create_order(nil, total_amount, nil)

    cart_items.each do |item|
      variant = CatalogueVariant.find(item.catalogue_variant_id)
      OrderItem.create!(
        order_id: order.id,
        catalogue_variant_id: variant.id,
        quantity: item.quantity,
        price: apply_subscription_discount(variant.discounted_price || variant.price)
      )
      variant.update!(quantity: variant.quantity - item.quantity)
    end
  end

  def create_order(variant, total_price, quantity)
    order = Order.create!(
      user_id: @current_user.id,
      total_price: total_price,
      status: 'paid'
    )
    if variant && quantity
      OrderItem.create!(
        order_id: order.id,
        catalogue_variant_id: variant.id,
        quantity: quantity,
        price: apply_subscription_discount(@variant_price)
      )
    end
    order
  end

  def create_stripe_customer(email, token)
    Stripe::Customer.create(email: email, source: token)
  end

  def create_stripe_charge(customer_id, amount, description)
    Stripe::Charge.create(
      customer: customer_id,
      amount: (amount * 100).to_i, # Amount in cents
      description: description,
      currency: 'usd'
    )
  end
end







