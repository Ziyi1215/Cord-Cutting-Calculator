# users_controller_spec.rb
# require 'spec_helper'
require 'rails_helper'
require "user"
 
describe UsersController, :type => :controller do
    
    describe "signup" do
        it 'should create a user successfully' do
            post :create, :params => {:user => {:username => 'user', :email => 'user@email.com', :password => 'password'}}
            expect(response).to redirect_to root_path
        end
        
        it 'should create a user unsuccessfully' do
            post :create, :params => {:user => {:username => nil, :email => nil, :password => nil}}
            expect(response).to render_template :new
        end
    end
    
    describe "login as user" do
    
        before :each do
            @user = User.create username: "user", email: "user@email.com", password: "password"
            session[:user_id] = @user.id
        end

        describe "UsersController#show" do
            it 'should render the show in views/users' do
                get :show, params: { id: session[:user_id] }
                expect(response).to render_template :show
            end           
        end
        
        describe "UsersController#edit" do
            it 'should render the edit in views/users' do
                get :edit, params: { id: session[:user_id] }
                expect(response).to render_template :edit
            end           
        end

        describe "UsersController#update" do
            let(:new_attributes) {
                { username: "new_user", email: "new_user@email.com" }}
            it 'should render show if information updated successfully' do
                put :update, params: {:id => @user.to_param, :user => new_attributes}
                @user.reload
                @user.username.should eq_to("new_user")
                @user.email.should eq_to("new_user@email.com")
                expect(response).to redirect_to user_path(session[:user_id])
            end           
        end
        
    end
    
end