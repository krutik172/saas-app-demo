FactoryBot.define do
  factory :goal do
    association :project
    description { "MyString" }
  end
end
