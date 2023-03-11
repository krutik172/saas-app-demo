FactoryBot.define do
  factory :ticket do
    association :project
    association :user
    status { 1 }
    description { "MyString" }
    comments { "MyString" }
  end
end
