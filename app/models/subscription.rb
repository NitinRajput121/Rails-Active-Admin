class Subscription < ApplicationRecord
	belongs_to :plan 
	belongs_to :user


  def expired?
    expires_at <= Time.current
  end

	
end
