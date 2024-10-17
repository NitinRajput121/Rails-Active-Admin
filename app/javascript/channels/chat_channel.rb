class ChatChannel < ApplicationCable::Channel
  def subscribed
    chat = Chat.find(params[:chat_id])
    stream_for chat
  end

  def receive(data)
    # Handle incoming messages
    ActionCable.server.broadcast("chat_#{params[:chat_id]}", data)
  end
end