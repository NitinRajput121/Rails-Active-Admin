class SubscriptionMailer < ApplicationMailer
  default from: 'Nitin'

  def expiration_notification(subscription)
    @subscription = subscription
    mail(to: @subscription.user.email, subject: 'Subscription Expiration Notice')
  end
end
