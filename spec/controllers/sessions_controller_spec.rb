# sessions_controller_spec.rb
require 'spec_helper'
 
describe SessionsController, :type => :controller do 
  
  # before do
  #   fake_user = double('user', :username => 'Me', :email => 'me@me.com') 
  # end
 
  # describe "#create" do
 
  #   it "should successfully create a user" do
  #     expect {
  #       post :create, params: {provider: 'google_oauth2'}
  #     }.to change{ User.count }.by(1)
  #   end
 
  #   it "should successfully create a session" do
  #     session[:user_id].should be_nil
  #     post :create, params: {provider: 'google_oauth2'}
  #     session[:user_id].should_not be_nil
  #   end
 
  #   it "should redirect the user to the root url" do
  #     post :create, params: {provider: 'google_oauth2'}
  #     response.should redirect_to root_url
  #   end
 
  # end
 
  # describe "#destroy" do
  #   before do
  #     post :create, params: {provider: 'google_oauth2'}
  #   end
 
  #   it "should clear the session" do
  #     session[:user_id].should_not be_nil
  #     delete :destroy
  #     session[:user_id].should be_nil
  #   end
 
  #   it "should redirect to the home page" do
  #     delete :destroy
  #     response.should redirect_to root_url
  #   end
  # end
 
end