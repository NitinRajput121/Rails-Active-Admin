# class Plan < ApplicationRecord
#   validates :price_monthly, :price_yearly, presence: true, if: :paid_plan?
#   validates :discount, :discount_type, :discount_percentage, presence: true, if: :paid_plan?

#   # Custom method to check if the plan is paid
#   def paid_plan?
#     plan_type == 'paid'
#   end

#   # Method to calculate discounted monthly price
#   def discounted_price_monthly
#     return price_monthly unless discount.present? && discount_percentage.present?

#     if discount_type == "Percentage"
#       price_monthly - (price_monthly * (discount_percentage.to_f / 100))
#     elsif discount_type == "Fixed"
#       price_monthly - discount_percentage.to_f
#     else
#       price_monthly
#     end
#   end

#   # Method to calculate discounted yearly price
#   def discounted_price_yearly
#     return price_yearly unless discount.present? && discount_percentage.present?

#     if discount_type == "Percentage"
#       price_yearly - (price_yearly * (discount_percentage.to_f / 100))
#     elsif discount_type == "Fixed"
#       price_yearly - discount_percentage.to_f
#     else
#       price_yearly
#     end
#   end
# end

class Plan < ApplicationRecord
  enum plan_type: { free: 0, paid: 1 }
  validates :price_monthly, :price_yearly, presence: true, if: :paid_plan?
  validates :discount, :discount_type, :discount_percentage, presence: true, if: :paid_plan?
  validates :name, presence: true
  validate :must_have_at_least_one_benefit
  # Custom method to check if the plan is paid
  def paid_plan?
    plan_type == 'paid'
  end

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


  def must_have_at_least_one_benefit
    if benefits.blank? || benefits.split(',').map(&:strip).empty?
      errors.add(:benefits, 'Please provide at least one benefit')
    elsif benefits.split(',').any? { |b| b.length > 200 }
      errors.add(:benefits, 'Each benefit should not exceed 200 characters')
    end
  end
end

