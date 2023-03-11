FactoryBot.define do
  factory :payment do
    email { "MyString" }
    token { "MyString" }
    user_id { nil }
  end
end
