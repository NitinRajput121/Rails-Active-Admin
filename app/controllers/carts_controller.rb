# class CartsController < ApplicationController

# skip_before_action :authorize_request, only: [:index,:create]

#  before_action :create

#   def index
#     render json: @cart
#   end


#   def create
#   	puts @current_user.id
#     if @current_user

#       @cart = Cart.find_or_create_by(user_id: current_user.id)
#     else
#       @cart = Cart.find_or_create_by(token: guest_cart_token)
#     end
#   end

#   private



#   def guest_cart_token
#     # Retrieve the guest token from the session or params
#     session[:guest_cart_token] ||= SecureRandom.hex(10)
#   end
# end



# class CartsController < ApplicationController
#   skip_before_action :authorize_request, only: [:index, :create]
#   before_action :identify_user, only: [:index, :create]
#   before_action :find_or_create_cart, only: [:index]

#   def index
#     render json: @cart, include: :cart_items
#   end

#   def create
#     if @current_user
#       # Find or create cart for logged-in user
#       @cart = Cart.find_or_create_by(user_id: @current_user.id)
#     else
#       # Find or create cart for guest user using the token
#       @cart = Cart.find_or_create_by(token: guest_cart_token)
#     end
#     render json: @cart
#   end

#   private

#   def identify_user
#     header = request.headers['Token']
#     if header.present?
#       token = header.split(' ').last
#       decoded = decode_token(token)
#       @current_user = User.find_by(id: decoded['user_id']) if decoded
#     end
#   end

#   def find_or_create_cart
#     if @current_user
#       # If a logged-in user is present, find or create the cart using user_id
#       @cart = Cart.find_or_create_by(user_id: @current_user.id)
#       else
#         @cart = Cart.find_or_create_by(token: guest_cart_token)
#     end
   
#   end

#   def guest_cart_token
#     session[:guest_cart_token] ||= SecureRandom.hex(10)
#   end

#   def decode_token(token)
#     JWT.decode(token, ENV['JWT_SECRET_KEY'], true, algorithm: 'HS256')[0]
#   rescue
#     nil
#   end
# end


# class CartsController < ApplicationController
#   # skip_before_action :authorize_request, only: [:index, :create]
#   before_action :find_or_create_cart, only: [:index]

#   def index
#     render json: @cart
#   end

#   def create
#     if @current_user
#       @cart = Cart.find_or_create_by(user_id: @current_user.id)
#     else
#       @cart = Cart.find_or_create_by(token: guest_cart_token)
#     end
#     render json: @cart
#   end

#   private

#   def find_or_create_cart
#     if @current_user
#       # For authenticated users
#       @cart = Cart.find_or_create_by(user_id: @current_user.id)
#     else
#       # For guest users, use session-based token
#       if session[:guest_cart_token].present?
#         @cart = Cart.find_or_create_by(token: session[:guest_cart_token])
#       else
#         @cart = Cart.find_or_create_by(token: guest_cart_token)
#       end
#     end
#   end

#   def guest_cart_token
#     # Generate a session token for the guest if it doesn't exist
#     session[:guest_cart_token] ||= SecureRandom.hex(10)
#   end
# end


class CartsController < ApplicationController
  before_action :find_or_create_cart, only: [:index]

  def index
    render json: @cart, each_serializer: CartSerializer
  end

  def create
    if @current_user
      @cart = Cart.find_or_create_by(user_id: @current_user.id)
    else
      @cart = Cart.find_or_create_by(token: guest_cart_token)
    end
    if @cart.persisted?
      render json: @cart
    else
      render json: { error: "Cart could not be saved", details: @cart.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def find_or_create_cart
    if @current_user
      @cart = Cart.find_or_create_by(user_id: @current_user.id)
    else
      @cart = Cart.find_or_create_by(token: guest_cart_token)
    end

    # Attempt to save the cart if it is new
    unless @cart.persisted?
      if @cart.save
        render json: @cart, status: :created
      else
        render json: { error: "Cart could not be saved", details: @cart.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def guest_cart_token
    params[:guest_cart_token] ||= SecureRandom.hex(10)
  end
end



