class PaymentsController < ApplicationController
  before_action :find_cart_items, only: [:purchase]
  before_action :find_single_item, only: [:purchase_single_item]

  # Handles the purchase of cart items
def purchase
  return render json: { error: 'No items in cart' }, status: :unprocessable_entity unless @cart_items.present?

  total_amount = calculate_total(@cart_items)

  # Log for debugging purposes
  puts "Total Amount: #{total_amount.inspect} (#{total_amount.class})"

  total_amount = total_amount.to_f

total_amount <= 0 ? (render(json: { error: 'Total amount must be greater than 0' }, status: :unprocessable_entity) && return) : nil


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


  # Handles the purchase of a single item
  def purchase_single_item
    return render json: { error: 'Invalid quantity or item not available' }, status: :unprocessable_entity unless @variant && @quantity_to_purchase > 0

    total_amount = apply_subscription_discount(@variant_price * @quantity_to_purchase)

    if total_amount <= 0
      return render json: { error: 'Invalid total amount for single item' }, status: :unprocessable_entity
    end

    customer = create_stripe_customer(params[:email], params[:token])
    charge = create_stripe_charge(customer.id, total_amount, "Purchase of #{@variant.catalogue.name}")

    if charge.paid
      @variant.update!(quantity: @variant.quantity - @quantity_to_purchase)
      order = create_order(@variant, total_amount, @quantity_to_purchase)
      render json: { message: 'Payment successful', order: order }, status: :ok
    else
      render json: { error: 'Payment failed' }, status: :unprocessable_entity
    end
  rescue Stripe::CardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  # Finds the items in the cart
  def find_cart_items
    @cart = Cart.find_by(user_id: @current_user.id)
    @cart_items = @cart ? @cart.cart_items : []
  end

  # Finds a single item to purchase
  def find_single_item
    @variant = CatalogueVariant.find_by(id: params[:variant_id])
    @quantity_to_purchase = params[:quantity].to_i

    if @variant.nil? || @variant.quantity < @quantity_to_purchase
      return render json: { error: 'Insufficient stock available' }, status: :unprocessable_entity
    end

    @variant_price = apply_subscription_discount(@variant.discounted_price || @variant.price)
  end

  # Calculates the total price of the cart
def calculate_total(cart_items)
  total_amount = 0
  cart_items.each do |item|
    variant = CatalogueVariant.find(item.catalogue_variant_id)
    
    # if variant.quantity < item.quantity
    #   render json: { error: "Insufficient stock for this variant" }, status: :unprocessable_entity
    #   return
    # end

    # Check stock and render error if necessary
variant.quantity < item.quantity ? (render(json: { error: "Insufficient stock for this variant" }, status: :unprocessable_entity) && return) : nil


    price_to_use = apply_subscription_discount(variant.discounted_price || variant.price)
    total_amount += price_to_use * item.quantity
  end

  total_amount # Ensure this is always a number
end

  # Applies subscription discount
  def apply_subscription_discount(price)
    if @current_user.subscription_active?
      # Apply a 5% discount if the user has an active subscription
      price -= (price * 0.05)
    end
    price
  end

  # Creates an order from the cart items
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

  # Creates an order
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

  # Creates a Stripe customer
  def create_stripe_customer(email, token)
    Stripe::Customer.create(email: email, source: token)
  end

  # Creates a Stripe charge
  def create_stripe_charge(customer_id, amount, description)
    Stripe::Charge.create(
      customer: customer_id,
      amount: (amount * 100).to_i, # Amount in cents
      description: description,
      currency: 'usd'
    )
  end
end







