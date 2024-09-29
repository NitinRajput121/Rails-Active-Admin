class User < ApplicationRecord

  has_secure_password

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :digested_password, presence: true
  validates :user_type, inclusion: { in: %w[seller customer] } # Example user types
  validates :authentication_type, inclusion: { in: %w[email phone] } 

  

end
