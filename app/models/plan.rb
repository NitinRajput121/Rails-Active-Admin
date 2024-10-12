

class Plan < ApplicationRecord
  enum plan_type: { free: 0, paid: 1 }
  validates :price_monthly, presence: true, if: :paid_plan?
  validates :discount, :discount_type, :discount_percentage, presence: true, if: :paid_plan?
  validates :name, presence: true
  # validate :must_have_at_least_one_benefit
  # Custom method to check if the plan is paid
  def paid_plan?
    plan_type == 'paid'
  end

  has_many :subscription

  # Method to calculate discounted monthly price
  def discounted_price_monthly
    return price_monthly unless discount.present? && discount_percentage.present?

    Rails.logger.debug "Calculating Discounted Price Monthly..."
    Rails.logger.debug "Original Monthly Price: #{price_monthly}, Discount Type: #{discount_type}, Discount Percentage: #{discount_percentage}"

    if discount_type == "Percentage"
      discounted_price = price_monthly - (price_monthly * (discount_percentage.to_f / 100))
      Rails.logger.debug "Discounted Monthly Price (Percentage): #{discounted_price}"
      discounted_price
    elsif discount_type == "Fixed"
      discounted_price = price_monthly - discount_percentage.to_f
      Rails.logger.debug "Discounted Monthly Price (Fixed): #{discounted_price}"
      discounted_price
    else
      price_monthly
    end
  end

  # Method to calculate discounted yearly price
  def discounted_price_yearly
    return price_yearly unless discount.present? && discount_percentage.present?

    Rails.logger.debug "Calculating Discounted Price Yearly..."
    Rails.logger.debug "Original Yearly Price: #{price_yearly}, Discount Type: #{discount_type}, Discount Percentage: #{discount_percentage}"

    if discount_type == "Percentage"
      discounted_price = price_yearly - (price_yearly * (discount_percentage.to_f / 100))
      Rails.logger.debug "Discounted Yearly Price (Percentage): #{discounted_price}"
      discounted_price
    elsif discount_type == "Fixed"
      discounted_price = price_yearly - discount_percentage.to_f
      Rails.logger.debug "Discounted Yearly Price (Fixed): #{discounted_price}"
      discounted_price
    else
      price_yearly
    end
  end

end

