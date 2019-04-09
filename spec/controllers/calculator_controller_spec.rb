# Calculator_controller_spec.rb

require 'rails_helper'
require "user"

describe CalculatorController, :type => :controller do

 describe "#open" do
     before :each do
      @user = User.create username: "user", email: "user@email.com", password: "password"
      session[:user_id] = @user.id
     end
     # it "should redirect to signin page" do
     #     get :show
     #     expect(response).to have_http_status(302)
     #     response.should redirect_to '/signin'
     # end

     # it "should open home page" do
     #     # user = User.create(first_name: "fofo", email: "fofo@gmail.com")
     #     channels = []
     #     ["hbo", "star", "abc", "news"].each do |channel_name|
     #         channels << Channel.create(name: channel_name).id
     #     end
     #     input_params = {
     #         :must_channels => [channels[0], channels[1]],
     #         :good_channels => [channels[2]],
     #         :okay_channels => [channels[3]]
     #     }
     #     get :input, :params => input_params, session: {:user_id => @user.id}
     #     expect(response).to have_http_status(200)
     # end
 end

end 