require 'test_helper'

class EventInterestsControllerTest < ActionController::TestCase
  setup do
    @event_interest = event_interests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:event_interests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event_interest" do
    assert_difference('EventInterest.count') do
      post :create, event_interest: { fbeventid: @event_interest.fbeventid, interestid: @event_interest.interestid }
    end

    assert_redirected_to event_interest_path(assigns(:event_interest))
  end

  test "should show event_interest" do
    get :show, id: @event_interest
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @event_interest
    assert_response :success
  end

  test "should update event_interest" do
    put :update, id: @event_interest, event_interest: { fbeventid: @event_interest.fbeventid, interestid: @event_interest.interestid }
    assert_redirected_to event_interest_path(assigns(:event_interest))
  end

  test "should destroy event_interest" do
    assert_difference('EventInterest.count', -1) do
      delete :destroy, id: @event_interest
    end

    assert_redirected_to event_interests_path
  end
end
