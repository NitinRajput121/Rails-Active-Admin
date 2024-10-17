class MessagesController < ApplicationController
  before_action :authorize_request
  before_action :set_chat

  # List all messages in the chat
def create
  message = @chat.messages.new(message_params.merge(user: @current_user))

  if message.save
    # Broadcast message with correct arguments
    ActionCable.server.broadcast(
      "chat_#{@chat.id}",  # The channel name
      {  # The data to be broadcasted
        message: message.content,
        user_id: @current_user.id
      }
    )
    render json: { message: message }, status: :created
  else
    render json: { error: message.errors.full_messages }, status: :unprocessable_entity
  end
end

  private

  # Set the chat based on the provided chat_id
  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  # Strong params for message content
  def message_params
    params.require(:message).permit(:content)
  end
end
