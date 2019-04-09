# channels_controller_spec.rb
require 'spec_helper'
 
describe ChannelsController, :type => :controller do
    before do
        @user = User.create username: "user", email: "user@email.com", password: "password"
        session[:user_id] = @user.id
        @channels = []
        ["hbo", "star", "abc", "news"].each do |channel_name|
         @channels << Channel.create(name: channel_name).id
        end
    end
    
    # describe "#redirect" do
    #     it "should redirect to signin page" do
    #         get :index, session: {:user_id => nil}
    #         expect(response).to have_http_status(302)
    #         # response.should redirect_to '/login'
    #     end
    # end
    
    describe "#CRUD Operations" do
        it "should get all channels information" do
            get :index, session: {:user_id => @user.id}
            expect(response).to have_http_status(200)
        end
        
        it "should show channel information" do
            get :show, params: {:id => @channels[0]}, session: {:user_id => @user.id}
            expect(response).to have_http_status(200)
        end
        
        it "should create a new channel" do
            post_params = {
                :channel => {:name => "Maa", :category => "Entertainment"}
            }
            post :create, params: post_params, session: {:user_id => @user.id}
            expect(response).to have_http_status(302)
            created_channel = Channel.where(:name => 'Maa').last
            response.should redirect_to "/channels/#{created_channel.id}"
        end
        
        it "should not create a new channel" do
            channel = Channel.create(name: "xyz")
            expect(channel).to receive(:save).and_return(false)
            Channel.stub(:new).and_return(channel)
            post_params = {
                :channel => {:name => "Maa", :category => "Entertainment"}
            }
            post :create, params: post_params, session: {:user_id => @user.id}
            expect(response).to have_http_status(200)
            expect(response).to render_template(:new)
        end
        
        it "should get the page for creating new channel" do
            get :new, session: {:user_id => @user.id}
            expect(response).to have_http_status(200)
        end
        
        it "should get the page to edit that particular channel" do
            get :edit, params: {:id => @channels[0]}, session: {:user_id => @user.id}
            expect(response).to have_http_status(200)
        end
        
        it "should successfully update the channel with user supplied information" do
            put_params = {
                :id => @channels[0],
                :channel => {:name => 1, :category => "Entertainment"}
            }
            put :update, params: put_params, session: {:user_id => @user.id}
            expect(response).to have_http_status(302)
            response.should redirect_to "/channels/#{@channels[0]}"
        end
        
        it "should not successfully update the channel with user supplied information" do
            channel = Channel.create(name: "xyz")
            expect(channel).to receive(:update).and_return(false)
            Channel.stub(:find).and_return(channel)
            put_params = {
                :id => @channels[0],
                :channel => {:name => 'hbo', :category => 'Entertainment'}
            }
            put :update, params: put_params, session: {:user_id => @user.id}
            expect(response).to have_http_status(200)
            expect(response).to render_template(:edit)
        end
        
        it "should delete a channel" do
            delete :destroy, params: {:id => @channels[0]}, session: {:user_id => @user.id}
            expect(response).to have_http_status(302)
            response.should redirect_to "/channels"
        end
    end
end