require 'test_helper'

class VirtualmachinesControllerTest < ActionController::TestCase
  setup do
    @virtualmachine = virtualmachines(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:virtualmachines)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create virtualmachine" do
    assert_difference('Virtualmachine.count') do
      post :create, virtualmachine: { label: @virtualmachine.label, remoteID: @virtualmachine.remoteID }
    end

    assert_redirected_to virtualmachine_path(assigns(:virtualmachine))
  end

  test "should show virtualmachine" do
    get :show, id: @virtualmachine
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @virtualmachine
    assert_response :success
  end

  test "should update virtualmachine" do
    patch :update, id: @virtualmachine, virtualmachine: { label: @virtualmachine.label, remoteID: @virtualmachine.remoteID }
    assert_redirected_to virtualmachine_path(assigns(:virtualmachine))
  end

  test "should destroy virtualmachine" do
    assert_difference('Virtualmachine.count', -1) do
      delete :destroy, id: @virtualmachine
    end

    assert_redirected_to virtualmachines_path
  end
end
