

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
      # UserMailer.login_notification(user).deliver_now
      # transfer_guest_cart_to_user(user) # Uncomment if needed
      render json: { token: token, message: "Login successful" }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def update
    user = User.find(params[:id])

    if user.update(user_params)
      render json: { message: 'User updated', data: user }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

def destroy
  user = User.find(params[:id])

  if user.destroy
    render json: { message: 'User deleted' }, status: :ok
  else
    render json: { error: 'Failed to delete user' }, status: :unprocessable_entity
  end
rescue ActiveRecord::RecordNotFound
  render json: { error: 'User not found' }, status: :not_found
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



