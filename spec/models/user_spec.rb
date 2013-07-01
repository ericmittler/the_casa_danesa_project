require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }

  describe 'aka' do
    it 'should return the value for aka' do
      user.aka = 'some value'
      user.aka.should == 'some value'
    end

    context 'when the value of aka is blank' do
      it 'should return full_name' do
        user.aka = ''
        user.first_name = 'Eric'
        user.last_name = 'Mittler'
        user.aka.should == 'Eric Mittler'
        user.aka.should == user.full_name
      end
    end
  end

  describe 'full_name' do
    it 'should return first_name + " " + last_name' do
      user.first_name = 'Eric'
      user.last_name = 'Mittler'
      user.full_name.should == 'Eric Mittler'
    end
  end

  describe 'registered?' do
    it 'should ensure email_validated' do
      user.registered?.should be_true
      user.email_validated = false
      user.registered?.should be_false
    end

    it 'should ensure first_name is not blank' do
      user.registered?.should be_true
      user.first_name = ''
      user.registered?.should be_false
    end

    it 'should ensure last_name is not blank' do
      user.registered?.should be_true
      user.last_name = ''
      user.registered?.should be_false
    end

    it 'should ensure email is not blank' do
      user.registered?.should be_true
      user.email = ''
      user.registered?.should be_false
    end
  end

end
