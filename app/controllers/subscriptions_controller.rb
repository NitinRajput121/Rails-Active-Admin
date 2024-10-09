
class SubscriptionsController < ApplicationController
  before_action :set_plan, only: [:create]
  
  def create

    if @current_user.subscription.present?
      return render json: { error: "You already have a subscription. Please upgrade your plan." }, status: :unprocessable_entity
    end 
    customer = find_or_create_stripe_customer(@current_user)
    payment_method_id = params[:payment_method_id]

    # Check if payment method is provided
    if payment_method_id.blank?
      return render json: { error: "Payment method ID is required." }, status: :unprocessable_entity
    end

    # Attach payment method to Stripe customer
    Stripe::PaymentMethod.attach(payment_method_id, { customer: customer.id })
    Stripe::Customer.update(customer.id, {
      invoice_settings: {
        default_payment_method: payment_method_id,
      },
    })

    final_price = calculate_final_price(@plan)

    # Create Payment Intent for subscription
    payment_intent = Stripe::PaymentIntent.create({
      amount: (final_price * 100).to_i,
      currency: 'usd',
      customer: customer.id,
      payment_method: payment_method_id,
      off_session: true,
      confirm: true,
    })

    # Create subscription in the database
    subscription = Subscription.create(
      user: @current_user,
      plan: @plan,
      started_at: Time.current,
      expires_at: Time.current + @plan.months.months
    )

    render json: { message: 'Subscription created successfully', subscription: subscription, payment_intent: payment_intent }, status: :created
  rescue Stripe::StripeError => e
    Rails.logger.error("Stripe error: #{e.message}")
    render json: { error: e.message }, status: :unprocessable_entity
  rescue StandardError => e
    Rails.logger.error("Standard error: #{e.message}")
    render json: { error: 'An error occurred while creating the subscription' }, status: :internal_server_error
  end

  private

  def set_plan
    @plan = Plan.find(params[:plan_id])
  end

  def find_or_create_stripe_customer(user)
    if user.stripe_customer_id.nil?
      create_stripe_customer(user)
    else
      Stripe::Customer.retrieve(user.stripe_customer_id)
    end
  end

  def create_stripe_customer(user)
    customer = Stripe::Customer.create({
      email: user.email,
      name: user.name,
    })

    user.update(stripe_customer_id: customer.id)

    customer
  end

  def calculate_final_price(plan)
    final_price = plan.price_monthly
    if plan.discount
      final_price -= (final_price * (plan.discount_percentage / 100.0))
      final_price = final_price * plan.months.to_i
    end
    final_price
  end
end





