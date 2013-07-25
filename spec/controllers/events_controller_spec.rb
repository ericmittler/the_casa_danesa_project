require 'spec_helper'

describe EventsController do

  let(:valid_attributes) { {"title" => "MyString"} }

  let(:event) { Event.create! valid_attributes }

  let(:user) { FactoryGirl.create(:registered_user) }

  before :each do
    request.env['HTTPS'] = 'on'
  end


  describe "GET index" do
    it 'should ensure_authenticated' do
      controller.should_receive(:ensure_registered)
      get :index
    end

    context 'when authenticated' do
      before :each do
        authenticate_for_specs(user)
      end

      it "assigns all events as @events" do
        events = [event]
        get :index, {}
        assigns(:events).should eq(events)
      end
    end
  end

  describe "GET show" do
    it 'should ensure_authenticated' do
      controller.should_receive(:ensure_registered)
      get :show, :id => event.id
    end


    context 'when authenticated' do
      before :each do
        authenticate_for_specs(user)
      end

      it "assigns the requested event as @event" do
        get :show, {:id => event.to_param}
        assigns(:event).should eq(event)
      end
    end
  end

  describe "GET new" do
    it 'should ensure_authenticated' do
      controller.should_receive(:ensure_registered)
      get :new
    end

    context 'when authenticated' do
      before :each do
        authenticate_for_specs(user)
      end

      it 'should ensure_event_manager' do
        controller.should_receive(:ensure_event_manager)
        get :new
      end

      it "assigns a new event as @event" do
        get :new, {}
        assigns(:event).should be_a_new(Event)
      end
    end
  end

  describe "GET edit" do
    it 'should ensure_authenticated' do
      controller.should_receive(:ensure_registered)
      get :edit, :id => event.id
    end

    context 'when authenticated' do
      before :each do
        authenticate_for_specs(user)
      end
      it 'should ensure_event_manager' do
        controller.should_receive(:ensure_event_manager)
        get :edit, :id => event.id
      end

      it "assigns the requested event as @event" do
        get :edit, {:id => event.id}
        assigns(:event).should eq(event)
      end
    end
  end

  describe "POST create" do
    it 'should ensure_authenticated' do
      controller.should_receive(:ensure_registered)
      post :create, {:event => valid_attributes}
    end

    context 'when authenticated' do
      before :each do
        authenticate_for_specs(user)
      end

      it 'should ensure_event_manager' do
        controller.should_receive(:ensure_event_manager)
        post :create, {:event => valid_attributes}
      end

      describe "with valid params" do
        it "creates a new Event" do
          expect {
            post :create, {:event => valid_attributes}
          }.to change(Event, :count).by(1)
        end

        it "assigns a newly created event as @event" do
          post :create, {:event => valid_attributes}
          assigns(:event).should be_a(Event)
          assigns(:event).should be_persisted
        end

        it "redirects to the created event" do
          post :create, {:event => valid_attributes}
          response.should redirect_to(Event.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved event as @event" do
          # Trigger the behavior that occurs when invalid params are submitted
          Event.any_instance.stub(:save).and_return(false)
          post :create, {:event => {"title" => ""}}
          assigns(:event).should be_a_new(Event)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Event.any_instance.stub(:save).and_return(false)
          post :create, {:event => {'title' => nil}}
          response.should render_template("new")
        end
      end
    end
  end

  describe "PUT update" do
    it 'should ensure_authenticated' do
      controller.should_receive(:ensure_registered)
      put :update, {:id => event.id, :event => valid_attributes}
    end

    context 'when authenticated' do
      before :each do
        authenticate_for_specs(user)
      end
      it 'should ensure_event_manager' do
        controller.should_receive(:ensure_event_manager)
        put :update, {:id => event.id, :event => valid_attributes}
      end

      describe "with valid params" do
        it "updates the requested event" do
          Event.any_instance.should_receive(:update_attributes).with({"title" => "MyString"})
          put :update, {:id => event.id, :event => {"title" => "MyString"}}
        end

        it "assigns the requested event as @event" do
          event = Event.create! valid_attributes
          put :update, {:id => event.id, :event => valid_attributes}
          assigns(:event).should eq(event)
        end

        it "redirects to the event" do
          event = Event.create! valid_attributes
          put :update, {:id => event.to_param, :event => valid_attributes}
          response.should redirect_to(event)
        end
      end

      describe "with invalid params" do
        it "assigns the event as @event" do
          event = Event.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Event.any_instance.stub(:save).and_return(false)
          put :update, {:id => event.to_param, :event => {"title" => "invalid value"}}
          assigns(:event).should eq(event)
        end

        it "re-renders the 'edit' template" do
          event = Event.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Event.any_instance.stub(:save).and_return(false)
          put :update, {:id => event.to_param, :event => {"title" => "invalid value"}}
          response.should render_template("edit")
        end
      end
    end
  end

  describe "DELETE destroy" do
    it 'should ensure_authenticated' do
      controller.should_receive(:ensure_registered)
      delete :destroy, {:id => event.to_param}
    end

    context 'when authenticated' do
      before :each do
        authenticate_for_specs(user)
      end

      it 'should ensure_event_manager' do
        controller.should_receive(:ensure_event_manager)
        delete :destroy, {:id => event.to_param}
      end

      it "destroys the requested event" do
        event = Event.create! valid_attributes
        expect {
          delete :destroy, {:id => event.to_param}
        }.to change(Event, :count).by(-1)
      end

      it "redirects to the events list" do
        puts "1. session[:user_id]: #{session[:user_id]}"
        event = Event.create! valid_attributes
        delete :destroy, {:id => event.to_param}
        response.should redirect_to(events_url)
      end
    end
  end
end
