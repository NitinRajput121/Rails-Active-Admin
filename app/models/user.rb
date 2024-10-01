class User < ApplicationRecord

  has_secure_password

  has_many :wishlists

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :user_type, inclusion: { in: %w[seller customer] } # Example user types


  

end
