require 'spec_helper'

describe Email do
  let(:confirmation) {
    Email.create!(:user_id => 1,
                        :address => 'joe@example.com')
  }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:address) }
  it { should validate_uniqueness_of(:address) }
  it { should allow_value("test@test.org").for(:address) }
  it { should_not allow_value("test@test").for(:address) }
  it { should belong_to(:user) }

  describe 'ensure_code' do
    it 'should assign a random 5 digit number to the code' do
      email = Email.new
      email.code.should be_blank
      email.ensure_code
      email.code.length.should == 6
      email.code.should match /[A-Z]\d{5}/
    end

    it 'should not change once assigned' do
      code = confirmation.code
      confirmation.ensure_code
      code.should == confirmation.code
    end

    it 'should be called before save' do
      email = Email.new(:user_id=>1, :address=>'a@example.com')
      email.code.should be_blank
      email.should_receive :ensure_code
      email.save
    end
  end

end
