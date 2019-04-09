# stream_packages_controller_spec.rb
require 'spec_helper'
 
describe StreamPackagesController, :type => :controller do
    before do
        @user = User.create username: "user", email: "user@email.com", password: "password"
        session[:user_id] = @user.id   
        @channels = []
        ["hbo", "star", "abc", "news"].each do |channel_name|
         @channels << Channel.create(name: channel_name).id
        end
        @stream_package = StreamPackage.create({
                    :name => "Sunrise", 
                    :cost => 5,
                    :channel_ids => [@channels[0], @channels[1]]
                })
    end
    
    # describe "#redirect" do
    #     it "should redirect to signin page" do
    #         get :index
    #         expect(response).to have_http_status(302)
    #         response.should redirect_to '/signin'
    #     end
    # end
    
    describe "#CRUD Operations" do
        it "should get all stream packages" do
            get :index, session: {:user_id => @user.id}
            expect(response).to have_http_status(200)
        end
        
        it "should create a new stream package" do
            post_params = {
                :stream_package => {
                    :name => "Sunrise2", 
                    :cost => 5,
                    :channel_ids => [@channels[0], @channels[1]]
                }
            }
            post :create, params: post_params, session: {:user_id => @user.id}
            expect(response).to have_http_status(302)
            created_package = StreamPackage.where(:name => 'Sunrise2').last
            response.should redirect_to "/stream_packages/#{created_package.id}"
        end
        
        it "should not create a new stream package" do
            package = StreamPackage.new
            expect(package).to receive(:save).and_return(false)
            StreamPackage.stub(:new).and_return(package)
            post_params = {
                :stream_package => {
                    :name => "Sunrise2", 
                    :cost => 5,
                    :channel_ids => [@channels[0], @channels[1]]
                }
            }
            post :create, params: post_params, session: {:user_id => @user.id}
            expect(response).to have_http_status(200)
            expect(response).to render_template(:new)
        end
        
        it "should get the page for creating new Streaming Package" do
            get :new, session: {:user_id => @user.id}
            expect(response).to have_http_status(200)
        end
        
        it "should get the page to edit that particular channel" do
            get :edit, params: {:id => @stream_package.id}, session: {:user_id => @user.id}
            expect(response).to have_http_status(200)
        end
        
        it "should show information of a particular streaming package" do
            get :show, params: {:id => @stream_package.id}, session: {:user_id => @user.id}
            expect(response).to have_http_status(200)
        end
        
        it "should successfully update the streaming package with user supplied channels" do
            put_params = {
                :id => @stream_package.id,
                :stream_package => {
                    :name => "Sunrise2", 
                    :cost => 5,
                    :channel_ids => [@channels[0], @channels[1]]
                }
            }
            put :update, params: put_params, session: {:user_id => @user.id}
            expect(response).to have_http_status(302)
            created_package = StreamPackage.where(:name => 'Sunrise2').last
            response.should redirect_to "/stream_packages/#{created_package.id}"
        end
        
        it "should not successfully update the streaming package with user supplied channels" do
            package = StreamPackage.new
            expect(package).to receive(:update).and_return(false)
            StreamPackage.stub(:find).and_return(package)
            put_params = {
                :id => @stream_package.id,
                :stream_package => {
                    :name => "Sunrise2", 
                    :cost => 5,
                    :channel_ids => [@channels[0], @channels[1]]
                }
            }
            put :update, params: put_params, session: {:user_id => @user.id}
            expect(response).to have_http_status(200)
            expect(response).to render_template(:edit)
        end
        
        it "should delete a streaming package" do
            delete :destroy, params: {:id => @stream_package.id}, session: {:user_id => @user.id}
            expect(response).to have_http_status(302)
            response.should redirect_to "/stream_packages"
        end
    end
end