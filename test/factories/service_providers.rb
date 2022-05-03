FactoryBot.define do
  factory :service_provider do
    name { "MyString" }
    about { "MyText" }
    street { "MyString" }
    city { "MyString" }
    state { "MyString" }
    zip { "MyString" }
    contact_person { "MyString" }
    phone { "MyString" }
    email { "MyString" }
    url { "MyString" }
    association :municipality
  end
end
