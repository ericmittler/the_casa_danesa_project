FactoryGirl.define do
  sequence :email do |n|
    "test#{n}@example.com"
  end

  factory :user do
    name "Testing User"
    email
    aka "Joe"
  end
end
