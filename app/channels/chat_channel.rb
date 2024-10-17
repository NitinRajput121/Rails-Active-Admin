class ChatChannel < ApplicationCable::Channel
  def subscribed
    # Stream from a chat-specific channel, e.g., for chat with ID 1
    stream_from "chat_#{params[:chat_id]}"
  end

  def unsubscribed
    # Clean up any resources when a client unsubscribes
  end

  def receive(data)
    # Action Cable receives data sent from the client
    ActionCable.server.broadcast("chat_#{params[:chat_id]}", data)
  end
end