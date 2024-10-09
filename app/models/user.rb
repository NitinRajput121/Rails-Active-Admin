class User < ApplicationRecord

  has_secure_password

  has_many :wishlists
  has_one :cart
  has_many :orders
  has_one :subscription

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :user_type, inclusion: { in: %w[seller customer] } # Example user types

def subscription_active?
  current_subscription = subscription 
  return false unless current_subscription 
  current_subscription.started_at <= Time.current && current_subscription.expires_at >= Time.current
end

  

end
