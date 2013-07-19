require 'spec_helper'

describe SessionsController do
  let(:user) { FactoryGirl.create(:user) }

  before :each do
    request.env['HTTPS'] = 'on'
  end

  describe 'post CREATE' do
    context 'when in development mode and developer requests access' do
      before :each do
        Rails.stub(:env).and_return('development')
        @developer = FactoryGirl.create(:user, :email => 'eric_mittler@mac.com')
        AuthenticationProvider.create!(
            :user_id=>@developer.id, :uid=>'test', :provider=>'developer authentication')
      end

      after :each do
        Rails.stub(:env).and_return('test')
      end

      it 'should set the current_user to the developer' do
        post :create
        session[:user_id].should == @developer.id
      end
    end

    context 'when a user fails to authenticate' do
      before :each do
        session[:user_id] = nil
      end

      it 'should redirect to failure' do
        controller.env['omniauth.auth'] = {'provider' => 'not provider', 'uid' => 'none'}
        User.stub!(:find).and_return nil
        AuthenticationProvider.stub(:from_omniauth).and_return nil
        post :create
        response.should redirect_to authenticate_url
        flash[:alert].downcase.should include('authentication failed')
      end
    end

    context 'when a user successfully authenticates' do
      before :each do
        controller.env['omniauth.auth'] = {'provider' => 'some-provider',
                                           'uid' => UUIDTools::UUID.timestamp_create.to_s}
      end

      it 'should set the session[:provider_id]' do
        session[:provider_uid].should be_nil
        post :create
        session[:provider_uid].should == controller.env['omniauth.auth']['uid']
      end

      context 'when the user has never authenticated with the given provider' do
        it 'should create a provider' do
          expect { post :create }.to change(AuthenticationProvider, :count).by(1)
          ap = AuthenticationProvider.last
          ap.uid.should == controller.env['omniauth.auth']['uid']
          ap.provider.should == 'some-provider'
        end
      end

      context 'when the user has authenticated before with the give provider' do
        before :each do
          AuthenticationProvider.find_or_create_by_provider_and_uid('some-provider',
                                                                    controller.env['omniauth.auth']['uid'])
        end
        it 'should not create a provider' do
          expect { post :create }.to change(AuthenticationProvider, :count).by(0)
        end
      end

      context 'where there is no user for the authenticated provider' do
        before :each do
          controller.env['omniauth.auth'] = {'provider' => 'some-provider',
                                             'uid' => UUIDTools::UUID.timestamp_create.to_s}
          @provider = AuthenticationProvider.create!(
              :uid => controller.env['omniauth.auth']['uid'],
              :user_id => nil, :provider=>'some-provider')
        end

        it 'should redirect to new_user_url' do
          post :create
          response.should redirect_to new_user_url
        end
      end

      context 'when there is a user for the authenticated provider' do
        before :each do
          controller.env['omniauth.auth'] = {'provider' => 'some-provider',
                                             'uid' => UUIDTools::UUID.timestamp_create.to_s}
          @provider = AuthenticationProvider.create!(
              :uid => controller.env['omniauth.auth']['uid'],
              :user_id => user.id, :provider=>'some-provider')
        end

        it 'should set the session[:user_id] to the users id' do
          post :create
          session[:user_id].should == user.id
        end

        it 'should log that the user has authenticated' do
          expect { post :create }.to change(UserActivity, :count).by(1)
          a = UserActivity.last
          a.user_id.should == user.id
          a.name.should == 'logged in'
        end

        context 'when there is a desired url' do
          it 'should redirect to the desired url' do
            session[:desired_url] = 'some/desired/url'
            post :create
            response.should redirect_to 'some/desired/url'
            flash[:notice].downcase.should include('authenticated via some-provider')
            session[:desired_url].should be_nil
          end
        end

        context 'when there is no desired url' do
          it 'should redirect to root' do
            session[:desired_url] = nil
            post :create
            response.should redirect_to root_url
            flash[:notice].downcase.should include('authenticated via some-provider')
          end
        end

        it 'should flash notice "signed in"' do
          post :create
          response.should redirect_to root_url
          flash[:notice].downcase.should include('authenticated via some-provider')
        end
      end
    end
  end

  describe 'DELETE destroy' do
    before :each do
      session[:user_id] = user.id
    end

    it 'should log user the sign out' do
      expect { delete :destroy }.to change(UserActivity, :count).by(1)
      a = UserActivity.last
      a.user_id.should == user.id
      a.name.should == 'signed out'
    end

    it 'should delete the session' do
      delete :destroy
      session[:user_id].should be_nil
      controller.send(:current_user).should be_nil
      controller.send(:logged_in?).should be_false
    end

    it 'should redirect to the root_url with a "Signed Out" notice' do
      delete :destroy
      response.should redirect_to root_url
      flash[:notice].downcase.should include('signed out')
    end
  end

  describe 'GET failure' do
    before :each do
      session[:user_id] = user.id
    end

    it 'should redirect to root_url and alert "Authentication Failed"' do
      get :failure
      response.should redirect_to root_url
      flash[:alert].downcase.should include('authentication failed')
    end
  end

  describe 'GET new' do
    it 'should render the new template' do
      get :new
      response.should be_success
      response.should render_template :new
    end
  end
end