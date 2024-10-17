class ChatChannel < ApplicationCable::Channel
  def subscribed
    chat = Chat.find(params[:chat_id])
    stream_for chat
  end

  def unsubscribed
    # Any cleanup when the user leaves the channel
  end
end