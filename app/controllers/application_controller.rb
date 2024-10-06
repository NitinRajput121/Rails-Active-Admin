
class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authorize_request

  include Pagy::Backend




  private 

  def pagination_metadata(pagy)
    {
      current_page: pagy.page,
      total_pages: pagy.pages,
      total_count: pagy.count
    }
  end




  def authorize_request
    header = request.headers['Token']
    token = header.split(' ').last if header

    if token
      decoded = decode_token(token)
      @current_user = User.find_by(id: decoded['user_id']) if decoded
    else
      @current_user = nil
    end
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    @current_user = nil 
  end


  def decode_token(token)
    JWT.decode(token, ENV['JWT_SECRET_KEY'], true, algorithm: 'HS256')[0]
  rescue JWT::DecodeError
    nil
  end

def current_user
  @current_user
end


end