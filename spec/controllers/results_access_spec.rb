#  describe "GET /stats" do
#    it 'should redirect anonymous users to the login path' do
#      get :statistics
#      response.should redirect_to(login_path)
#    end
#
#    it 'should redirect non-admin users to the login path' do
#      controller.stub!(:current_school).and_return(mock_school(:admin => false))
#      get :statistics
#      response.should redirect_to(login_path)
#    end
#    it 'should allow admin users' do
#      controller.stub!(:current_school).and_return(mock_school(:admin => true))
#      get :statistics
#      response.should be_success
#    end
#  end
