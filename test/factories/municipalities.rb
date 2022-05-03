FactoryBot.define do
  factory :municipality do
    association :organization
    name { "MyString" }
    url { "MyString" }
  end
end
