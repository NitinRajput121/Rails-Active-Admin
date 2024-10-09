class SubscriptionExpirationJob < ApplicationJob
  queue_as :default

  def perform
    current_time = Time.current
    one_day_from_now = current_time + 1.day


    expiring_subscriptions = Subscription.where('expires_at <= ?', one_day_from_now)


    expiring_subscriptions.each do |subscription|
      SubscriptionMailer.expiration_notification(subscription).deliver_now
      Rails.logger.info "Sent expiration notification for Subscription ID: #{subscription.id}"
      

      if subscription.expires_at < current_time
        Rails.logger.info "Deleting Subscription ID: #{subscription.id}"
        subscription.destroy
      end
    end
  end
end
