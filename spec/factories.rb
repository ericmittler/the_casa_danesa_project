FactoryGirl.define do
  sequence :email do |n|
    "test#{n}@example.com"
  end

  factory :user do
    first_name "Testing"
    last_name "User"
    email
    email_validated true
    aka "Joe"
  end
end
