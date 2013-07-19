require 'spec_helper'

describe Registration do
  it 'should auto-generate a code on create' do
    reg = Registration.create(:user_id => 1)
    reg.code.should_not be_blank
  end

  it 'should not allow code to be changed' do
    reg = Registration.create(:user_id => 1)
    reg.code = 'some new code'
    reg.code.should_not == 'some new code'
  end

  it 'should require a user_id' do
    reg = Registration.create
    reg.should_not be_valid
    reg.error_on(:user_id).should == ["can't be blank"]
  end
end
