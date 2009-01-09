require 'test_helper'

class ProctorsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:proctors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create proctor" do
    assert_difference('Proctor.count') do
      post :create, :proctor => { }
    end

    assert_redirected_to proctor_path(assigns(:proctor))
  end

  test "should show proctor" do
    get :show, :id => proctors(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => proctors(:one).id
    assert_response :success
  end

  test "should update proctor" do
    put :update, :id => proctors(:one).id, :proctor => { }
    assert_redirected_to proctor_path(assigns(:proctor))
  end

  test "should destroy proctor" do
    assert_difference('Proctor.count', -1) do
      delete :destroy, :id => proctors(:one).id
    end

    assert_redirected_to proctors_path
  end
end
