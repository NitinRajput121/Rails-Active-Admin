class Subscription < ApplicationRecord
	belongs_to :plan 
	belongs_to :user


  validates :started_at, presence: true
  validates :expires_at, presence: true


  def expired?
    expires_at <= Time.current
  end

	
end
