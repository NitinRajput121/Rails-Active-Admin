# class CartItemsController < ApplicationController

# end

class CartItemsController < ApplicationController

  before_action :find_cart

  def index
    cart_items = @cart.cart_items
    render json: cart_items
  end

  def create
    cart_item = @cart.cart_items.find_or_initialize_by(catalogue_variant_id: cart_item_params[:catalogue_variant_id])
  if cart_item.persisted?
    render json: { message: "Item is already in cart" }, status: :ok
    return
  end
    cart_item.quantity ||= 0
    cart_item.quantity += cart_item_params[:quantity].to_i
    if cart_item.save
      render json: cart_item, status: :created
    else
      render json: { error: cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end



def update
  cart_item = @cart.cart_items.find(params[:id])
  cart_item.quantity += 1
  if cart_item.save
    render json: cart_item
  else
    render json: { error: cart_item.errors.full_messages }, status: :unprocessable_entity
  end
end


  def destroy
    cart_item = @cart.cart_items.find(params[:id])
    cart_item.destroy
    head :no_content
  end

  private

  def find_cart
    if @current_user
      @cart = Cart.find_or_create_by(user_id: @current_user.id)
    else
      @cart = Cart.find_or_create_by(token: guest_cart_token)
      puts guest_cart_token
    end
  end

  def cart_item_params
    params.require(:cart_item).permit(:catalogue_variant_id, :quantity)
  end

  def guest_cart_token
    params[:guest_cart_token] ||= SecureRandom.hex(10)
  end
end

