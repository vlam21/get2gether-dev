require 'test_helper'

class UserInterestsControllerTest < ActionController::TestCase
  setup do
    @user_interest = user_interests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_interests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_interest" do
    assert_difference('UserInterest.count') do
      post :create, user_interest: { fbid: @user_interest.fbid, interestid: @user_interest.interestid }
    end

    assert_redirected_to user_interest_path(assigns(:user_interest))
  end

  test "should show user_interest" do
    get :show, id: @user_interest
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_interest
    assert_response :success
  end

  test "should update user_interest" do
    put :update, id: @user_interest, user_interest: { fbid: @user_interest.fbid, interestid: @user_interest.interestid }
    assert_redirected_to user_interest_path(assigns(:user_interest))
  end

  test "should destroy user_interest" do
    assert_difference('UserInterest.count', -1) do
      delete :destroy, id: @user_interest
    end

    assert_redirected_to user_interests_path
  end
end
