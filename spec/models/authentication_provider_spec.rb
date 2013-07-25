require 'spec_helper'

describe AuthenticationProvider do

  let(:auth) {
    {'provider' => 'some-provider',
     'uid' => 'some-uid',
     'info' => 'some-info',
     'extra' => 'some-extra'}
  }

  it { should validate_presence_of :provider }
  it { should validate_presence_of :uid }
  it { should belong_to :user }

  describe 'create_from_omniauth' do
    it 'should return a created an AuthenticationProvider' do
      ap = AuthenticationProvider.create_from_omniauth(auth)
      ap.provider.should == auth['provider']
      ap.uid.should == auth['uid']
    end
  end

  describe 'from_omniauth' do
    it 'should create_from_omniauth if new' do
      AuthenticationProvider.should_receive(:create_from_omniauth).and_call_original
      ap = AuthenticationProvider.from_omniauth(auth)
    end

    it 'should return an existing AuthenticationProvider if exists' do
      existing = AuthenticationProvider.create_from_omniauth(auth)
      found = AuthenticationProvider.from_omniauth(auth)
      found.should == existing
    end

    it 'should update the info and extra' do
      ap = AuthenticationProvider.from_omniauth(auth)
      ap.info.should == auth['info'].to_yaml
      ap.extra.should == auth['extra'].to_yaml
    end
  end
end
