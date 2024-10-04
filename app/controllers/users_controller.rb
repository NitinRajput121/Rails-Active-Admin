# class UsersController < ApplicationController

# skip_before_action :authorize_request, only: [:create, :login]
  
# 	def create
#     @user = User.new(user_params)
    
#     if @user.save
  
#       render json: { message: 'user created', data:@user }, status: :ok
#     else
#       render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
#     end
#   end


#   def login
#     user = User.find_by(email: params[:email])

#     if user && user.authenticate(params[:password])
#       token = encode_token({ user_id: user.id })
#       render json: { token: token,message: "login successfully" }, status: :ok
#     else
#       render json: { error: 'Invalid email or password' }, status: :unauthorized
#     end
#   end


#   private

#   def user_params
#     params.require(:user).permit(:name, :email, :password, :user_type)
#   end


#   def encode_token(payload)
#     JWT.encode(payload, ENV['JWT_SECRET_KEY'])
#   end




# end




class UsersController < ApplicationController
  skip_before_action :authorize_request, only: [:create, :login]

def create
  user = User.new(user_params)

  if user.save
    if params[:guest_cart_token].present?
      transfer_guest_cart_to_user(user) 
    end
    render json: { message: 'User created', data: user }, status: :ok
  else
    render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
  end
end

  def login
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      token = encode_token({ user_id: user.id })
      # transfer_guest_cart_to_user(user)
      render json: { token: token, message: "Login successful" }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :user_type)
  end

  def encode_token(payload)
    JWT.encode(payload, ENV['JWT_SECRET_KEY'])
  end

  def transfer_guest_cart_to_user(user)
    guest_cart = Cart.find_by(token: params[:guest_cart_token])

    if guest_cart
      guest_cart.update(user_id: user.id, token: nil)
      # session.delete(:guest_cart_token)
    end
  end
end


