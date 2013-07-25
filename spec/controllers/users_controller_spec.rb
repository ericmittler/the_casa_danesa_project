require 'spec_helper'

describe UsersController do
  let(:user) { FactoryGirl.create(:registered_user) }

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
      let(:valid_params) {
        {'email' => "#{UUIDTools::UUID.timestamp_create}@example.com",
         'first_name' => 'Joe',
         'last_name' => 'Smoe'}
      }

      let(:provider) {
        AuthenticationProvider.create!(:provider => 'foo',
                                       :uid => UUIDTools::UUID.timestamp_create.to_s)

      }

      before :each do
        session[:provider_uid] = provider.uid
      end

      context 'when the provider already has a user associated with it' do
        before :each do
          provider.update_attributes(:user_id => user.id)
        end

        it 'should redirect to edit_user_url' do
          post :create, valid_params
          response.should redirect_to edit_user_url(user.id)
        end
      end

      context 'when there is no user assocaited with the provider' do
        context 'when the email provided is novel' do
          it 'should create a new user with that (unconfirmed) email_address' do
            expect { post :create, valid_params }.to change(User, :count).by(1)
            primary_email = User.last.primary_email
            primary_email.address.should == valid_params['email']
            primary_email.should be_primary
            primary_email.should_not be_confirmed
          end

          context 'when the email provide is not valid' do
            it 'should create a new user without an email' do
              valid_params['email'] = 'an invalid email address'
              expect { post :create, valid_params }.to change(User, :count).by(1)
              User.last.emails.length.should == 0
            end
          end
        end

        context 'when the email already exists' do
          before :each do
            Email.create!(:address => valid_params['email'], :user_id => 0)
          end

          it 'should not create a new user' do
            expect { post :create, valid_params }.to_not change(User, :count)
          end

          it 'should redirect to new_user_url' do
            post :create, valid_params
            response.should redirect_to new_user_url
            flash[:notice].should == 'The email provided is already associated with another user.'
          end
        end
      end
    end
  end

  describe 'destroy delete' do
    it 'should ensure_authenticated' do
      controller.should_receive(:ensure_authenticated)
      delete :destroy, :id => user.id
    end
  end

  describe 'get edit' do
    before :each do
      @provider = AuthenticationProvider.create!(:provider => 'foo', :uid => UUIDTools::UUID.timestamp_create.to_s)
      session[:provider_uid] = @provider.uid
    end

    it 'should ensure_authenticated' do
      controller.should_receive(:ensure_authenticated)
      get :edit, :id => user.id
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