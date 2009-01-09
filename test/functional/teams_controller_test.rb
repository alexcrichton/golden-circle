require 'test_helper'

class TeamsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:teams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create team" do
    assert_difference('Team.count') do
      post :create, :team => { }
    end

    assert_redirected_to team_path(assigns(:team))
  end

  test "should show team" do
    get :show, :id => teams(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => teams(:one).id
    assert_response :success
  end

  test "should update team" do
    put :update, :id => teams(:one).id, :team => { }
    assert_redirected_to team_path(assigns(:team))
  end

  test "should destroy team" do
    assert_difference('Team.count', -1) do
      delete :destroy, :id => teams(:one).id
    end

    assert_redirected_to teams_path
  end
end
