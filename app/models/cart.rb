class Cart < ApplicationRecord
  belongs_to :user, optional: true
  has_many :cart_items, dependent: :destroy


  validate :user_or_token_present


  private


  def user_or_token_present
    if user_id.nil? && token.blank?
      errors.add(:base, "Cart must belong to a user or have a token")
    end
  end




end
