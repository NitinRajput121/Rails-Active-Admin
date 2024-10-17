FactoryBot.define do
  factory :message do
    chat_id { 1 }
    user_id { 1 }
    content { "MyText" }
  end
end
