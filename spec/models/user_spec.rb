require 'spec_helper'

describe User do

  let(:registered_user) { FactoryGirl.create(:registered_user) }

  it { should have_many :authentication_providers }
  it { should have_many :emails }

  describe 'aka' do
    it 'should return the value for aka' do
      registered_user.aka = 'some value'
      registered_user.aka.should == 'some value'
    end

    context 'when the value of aka is blank' do
      it 'should return full_name' do
        registered_user.aka = ''
        registered_user.first_name = 'Eric'
        registered_user.last_name = 'Mittler'
        registered_user.aka.should == 'Eric Mittler'
        registered_user.aka.should == registered_user.full_name
      end
    end
  end

  describe 'full_name' do
    it 'should return first_name + " " + last_name' do
      registered_user.first_name = 'Eric'
      registered_user.last_name = 'Mittler'
      registered_user.full_name.should == 'Eric Mittler'
    end
  end

  describe 'primary_email' do
    it 'should return the primary email address' do
      user = FactoryGirl.create(:unregistered_user)
      user.primary_email.should be_nil
      email1 = FactoryGirl.create(:email, :user_id => user.id, :primary => false)
      user.reload.primary_email.should == email1
      email2 = FactoryGirl.create(:email, :user_id => user.id, :primary => false)
      user.primary_email.should == email1
      email2.update_attributes(:primary => true)
      user.reload.primary_email.should == email2
      email3 = FactoryGirl.create(:email, :user_id => user.id, :primary => true)
      user.primary_email.should == email2
    end
  end

  describe 'registered?' do
    it 'should ensure confirmed primary email' do
      user = registered_user
      user.registered?.should be_true
      user.primary_email.update_attributes(:confirmed => false)
      user.registered?.should be_false
      user.primary_email.update_attributes(:confirmed => true)
      user.registered?.should be_true
      user.primary_email.destroy
      user.reload.registered?.should be_false
    end

    it 'should ensure first_name is not blank' do
      registered_user.registered?.should be_true
      registered_user.first_name = ''
      registered_user.registered?.should be_false
    end

    it 'should ensure last_name is not blank' do
      registered_user.registered?.should be_true
      registered_user.last_name = ''
      registered_user.registered?.should be_false
    end
  end

  describe '@find_by_email' do
    it 'should return the user for a given email address' do
      user1 = FactoryGirl.create(:registered_user)
      user2 = FactoryGirl.create(:registered_user)
      user1.emails.create(:address=>'a@b.com')
      user1.emails.create(:address=>'c@d.com')
      user2.emails.create(:address=>'e@f.com')
      User.find_by_email('g@h.com').should be_nil
      User.find_by_email('a@b.com').should == user1
      User.find_by_email('c@d.com').should == user1
      User.find_by_email('e@f.com').should == user2
    end
  end

end
