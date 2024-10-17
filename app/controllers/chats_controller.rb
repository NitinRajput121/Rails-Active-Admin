class ChatsController < ApplicationController
  before_action :authorize_request

  # Create a new chat between customer and seller
  def create
    # Ensure one user is a customer and the other is a seller
    if (chat_params[:customer_id] && chat_params[:seller_id])
      customer = User.find_by(id: chat_params[:customer_id], user_type: 'customer')
      seller = User.find_by(id: chat_params[:seller_id], user_type: 'seller')

      # Check if both the customer and seller exist
      if customer && seller
        # Create or find the chat between the customer and seller
        chat = Chat.find_or_create_by(customer: customer, seller: seller)
        render json: { chat: chat }, status: :created
      else
        render json: { error: 'Invalid customer or seller' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Both customer_id and seller_id are required' }, status: :unprocessable_entity
    end
  end

  # Fetch all chats for the current user
  def index
    chats = if @current_user.user_type == 'customer'
              @current_user.chats_as_customer
            elsif @current_user.user_type == 'seller'
              @current_user.chats_as_seller
            else
              []
            end
    render json: { chats: chats }, status: :ok
  end

  private

  def chat_params
    params.require(:chat).permit(:customer_id, :seller_id)
  end
end


