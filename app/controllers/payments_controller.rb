class PaymentsController < ApplicationController
  def purchase
    # Find or create the cart
    cart = params[:cart_id] ? Cart.find(params[:cart_id]) : nil
    cart_items = cart.present? ? cart.cart_items : nil

    if cart_items.present?
      # Calculate total for cart items
      total_amount = 0
      cart_items.each do |item|
        variant = CatalogueVariant.find(item.catalogue_variant_id)
        if variant.quantity < item.quantity.to_i
          return render json: { error: "Insufficient stock for #{variant.catalogue.name}" }, status: :unprocessable_entity
        end
        
        # Calculate price based on whether there's an offer
        price_to_use = variant.discounted_price || variant.price
        total_amount += price_to_use * item.quantity.to_i
      end

      # Stripe customer and charge
      customer = Stripe::Customer.create(
        email: params[:email],
        source: params[:token]
      )

      charge = Stripe::Charge.create(
        customer: customer.id,
        amount: (total_amount * 100).to_i, # Amount in cents
        description: "Purchase of cart items",
        currency: 'usd'
      )

      if charge.paid
        # Deduct stock and save order details
        create_order_from_cart(cart_items, total_amount)

        render json: { message: 'Payment successful', charge: charge }, status: :ok
      else
        render json: { error: 'Payment failed' }, status: :unprocessable_entity
      end

    else
      # Direct purchase logic (if cart is not provided)
      purchase_single_item
    end
  rescue Stripe::CardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def create_order_from_cart(cart_items, total_amount)
    order = Order.create(
      user_id: @current_user.id, # Use current_user here
      total_price: total_amount,
      status: 'paid'
    )

    cart_items.each do |item|
      variant = CatalogueVariant.find(item.catalogue_variant_id)
      OrderItem.create(
        order_id: order.id,
        catalogue_variant_id: variant.id,
        quantity: item.quantity,
        price: variant.discounted_price || variant.price
      )

      # Deduct stock
      variant.update(quantity: variant.quantity - item.quantity.to_i)
    end
  end

  def purchase_single_item
    variant = CatalogueVariant.find(params[:variant_id])
    quantity_to_purchase = params[:quantity].to_i

    if variant.quantity < quantity_to_purchase
      return render json: { error: 'Insufficient stock available' }, status: :unprocessable_entity
    end

    # Calculate price based on whether there's an offer
    price_to_use = variant.discounted_price || variant.price

    customer = Stripe::Customer.create(
      email: params[:email],
      source: params[:token]
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: (price_to_use * quantity_to_purchase * 100).to_i,
      description: "Purchase of #{variant.catalogue.name}",
      currency: 'usd'
    )

    if charge.paid
      variant.update(quantity: variant.quantity - quantity_to_purchase)

      # Create order for the single item
      order = Order.create(
        user_id: @current_user.id, # Use current_user here
        total_price: price_to_use * quantity_to_purchase,
        status: 'paid'
      )

      OrderItem.create(
        order_id: order.id,
        catalogue_variant_id: variant.id,
        quantity: quantity_to_purchase,
        price: price_to_use
      )

      render json: { message: 'Payment successful', order: order }, status: :ok
    else
      render json: { error: 'Payment failed' }, status: :unprocessable_entity
    end
  end
end
