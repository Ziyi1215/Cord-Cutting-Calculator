# users_controller_spec.rb
require 'spec_helper'
 
describe UsersController, :type => :controller do
    
    describe "signup" do
        it "should redirect to root page" do
            fake_user = double('user', :username => 'Me', :email => 'me@me.com') 
            expect(User).to receive(:find).with('1').and_return(fake_movie) 
            expect(response).to redirect_to(root_path)
        end
    end
    
    before do
        @user = User.create(username: "fofo", email: "fofo@gmail.com")
        @channels = []
        ["hbo", "star", "abc", "news"].each do |channel_name|
         @channels << Channel.create(name: channel_name).id
        end
    end
    
    describe "#redirect" do
        it "should redirect to login page" do
            get :login
            expect(response).to have_http_status(302)
            response.should redirect_to '/login'
        end
    end
    
    describe "#input" do
        it "should open user input" do
            get :input, session: {:user_id => @user.id}
            expect(response).to have_http_status(200)
        end
        
        it "should open user input with previous history" do
            @user.add_channels([@channels[0], @channels[1]], 'must')
            @user.add_channels([@channels[2]], 'good')
            @user.add_channels([@channels[3]], 'ok')
            @user.save()
            
            get :input, session: {:user_id => @user.id}
            expect(response).to have_http_status(200)
        end
    end
    
    describe "#recomendation" do
        it "should redirect to user input page after get recommendation" do
            input_params = {
             :must_channel_ids => [@channels[0], @channels[1]],
             :good_channel_ids => [@channels[2]],
             :ok_channel_ids => [@channels[3]],
             :budget => 100
            }
            post :recommendation, params: input_params, session: {:user_id => @user.id}
            response.should redirect_to '/user/input'
        end
    end
end