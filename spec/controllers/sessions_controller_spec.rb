# sessions_controller_spec.rb
require 'rails_helper'
require "user"

describe SessionsController, :type => :controller do 

  describe "#create" do

    before :each do
      @user_a = User.create! username: "user_a", email: "user_a@email.com", password: "password"
    end

    it "should successfully create a user" do
      expect(@user_a).to be_valid
      # response.should redirect_to user_path(@user_a.id)
      # expect {
      #   post :create, params: {username: "user_a", email: "user_a@email.com", password: "password"}
      # }.to change{ User.count }.by(1)
    end

    it "should successfully create a session" do
      session[:user_id].should be_nil
      session[:user_id] = @user_a.id
      session[:user_id].should_not be_nil
    end

    # it "should redirect the user to the root url" do
    #   user_b = User.create! username: "user_b", email: "user_b@email.com", password: "password"
    #   response.should redirect_to user_path(user_b.id)
    # end

  end

  describe "#destroy" do

    before :each do
      @user_b = User.create! username: "user_b", email: "user_b@email.com", password: "password"
    end
    it "should clear the session" do
      session[:user_id] = @user_b.id
      session[:user_id].should_not be_nil
      delete :destroy
      session[:user_id].should be_nil
    end

    it "should redirect to the home page" do
      delete :destroy
      response.should redirect_to root_path
    end
  end
 
end