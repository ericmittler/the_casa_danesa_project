FactoryGirl.define do

  factory :unregistered_user, :class => User do
    first_name "Unreggie"
    last_name "User"
    aka "Joe"
  end

  factory :registered_user, :class => User do
    first_name "Reggie"
    last_name "User"
    aka "Joe"
    after :create do |registered_user|
      FactoryGirl.create :email, primary: true, user: registered_user
    end
  end

  factory :email do
    code 'some-code'
    sequence(:address) {|n| "joe.#{n}.#{Time.now.to_i}@example.com"}
    confirmed true
    primary false
    user_id 0
  end

end
