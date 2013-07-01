require 'spec_helper'

describe UsersController do
  let(:user) { FactoryGirl.create(:user) }

  before :each do
    request.env['HTTPS'] = 'on'
  end

  describe 'post create' do
    context 'where there is no authentication provider' do
      it 'should redirect to authenticate_url' do
        session[:provider_uid] = nil
        post :create
        response.should redirect_to authenticate_url
      end
    end

    context 'where there is an authentication provider' do
      let(:valid_params) { {'email' => "e#{UUIDTools::UUID.timestamp_create.to_s}@example.com",
                            'first_name' => 'Joe', 'last_name' => 'Smoe'} }
      before :each do
        @provider = AuthenitcationProvider.create!(:provider => 'foo', :uid => UUIDTools::UUID.timestamp_create.to_s)
        session[:provider_uid] = @provider.uid
      end

      context 'where a valid params are provided' do

        it 'should associate the provider with the user' do
          post :create, valid_params
          user = User.find_by_email valid_params['email']
          @provider.reload.user.should == user
        end

        it 'should flash notice that an email has been sent' do
          post :create, valid_params
          flash[:notice].downcase.should include('mail has been sent')
        end

        context 'when the email address is new/novel' do
          it 'should create a user with the params' do
            expect { post :create, valid_params }.to change(User, :count).by(1)
            user = User.last
            user.email.should == valid_params['email']
            user.first_name.should == valid_params['first_name']
            user.last_name.should == valid_params['last_name']
            user.email_validated.should be_false
            user.event_manager.should be_false
          end

          it 'should redirect to edit_user_url for the created user' do
            post :create, valid_params
            user = User.last
            response.should redirect_to edit_user_url(user)
          end
        end

        context 'when the email address matches an existing users address' do
          before :each do
            @user = User.create('email' => valid_params['email'],
                                'first_name' => 'a', 'last_name' => 'b')
          end

          it 'should update the found user name' do
            expect { post :create, valid_params }.to change(User, :count).by(0)
            user = User.find_by_email valid_params['email']
            user.email.should == valid_params['email']
            user.first_name.should == valid_params['first_name']
            user.last_name.should == valid_params['last_name']
            user.email_validated.should be_false
            user.event_manager.should be_false
          end

          it 'should redirect to edit_user_url for the found user' do
            post :create, valid_params
            user = User.find_by_email valid_params['email']
            response.should redirect_to edit_user_url(user)
          end
        end
      end
    end
  end

  describe 'get new' do
    it 'should provide a new user' do
      get :new
      assigns(:user).should be_a(User)
      assigns(:user).new_record?.should be_true
    end
  end
end