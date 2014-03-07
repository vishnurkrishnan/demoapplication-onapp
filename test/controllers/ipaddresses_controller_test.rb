require 'test_helper'

class IpaddressesControllerTest < ActionController::TestCase
  setup do
    @ipaddress = ipaddresses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ipaddresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ipaddress" do
    assert_difference('Ipaddress.count') do
      post :create, ipaddress: {  }
    end

    assert_redirected_to ipaddress_path(assigns(:ipaddress))
  end

  test "should show ipaddress" do
    get :show, id: @ipaddress
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ipaddress
    assert_response :success
  end

  test "should update ipaddress" do
    patch :update, id: @ipaddress, ipaddress: {  }
    assert_redirected_to ipaddress_path(assigns(:ipaddress))
  end

  test "should destroy ipaddress" do
    assert_difference('Ipaddress.count', -1) do
      delete :destroy, id: @ipaddress
    end

    assert_redirected_to ipaddresses_path
  end
end
