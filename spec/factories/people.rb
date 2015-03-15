FactoryGirl.define do
  factory :person do
    sequence(:name) { |n| "FirstName#{n} LastName#{n}" }
    sequence(:email) { |n| "email#{n}@cran.org" }
  end
end
