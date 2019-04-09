require 'rails_helper'
require "user"

RSpec.describe User do

  before :each do
    @user1 = User.create username: "user1", email: "user1@email.com", password: "password"
  end
  
    it "is valid with valid attributes" do
      expect(@user1).to be_valid
    end

    it "is not valid without a email" do
       @user1.email = nil
       expect(@user1).to_not be_valid
    end

    it "is not valid without a username" do
      @user1.username = nil
      expect(@user1).to_not be_valid
    end
    
end