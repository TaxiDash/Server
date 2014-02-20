require 'test_helper'

class DriversControllerTest < ActionController::TestCase
  setup do
    @driver = drivers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:drivers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create driver" do
    assert_difference('Driver.count') do
      post :create, driver: { address: @driver.address, average_rating: @driver.average_rating, city: @driver.city, company_name: @driver.company_name, dob: @driver.dob, first_name: @driver.first_name, height: @driver.height, last_name: @driver.last_name, license: @driver.license, middle_name: @driver.middle_name, owner: @driver.owner, permit_expiration_date: @driver.permit_expiration_date, permit_number: @driver.permit_number, phone_number: @driver.phone_number, physical_expiration_date: @driver.physical_expiration_date, race: @driver.race, sex: @driver.sex, state: @driver.state, status: @driver.status, total_ratings: @driver.total_ratings, training_completion_date: @driver.training_completion_date, type_id: @driver.type_id, valid: @driver.valid, weight: @driver.weight, zipcode: @driver.zipcode }
    end

    assert_redirected_to driver_path(assigns(:driver))
  end

  test "should show driver" do
    get :show, id: @driver
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @driver
    assert_response :success
  end

  test "should update driver" do
    patch :update, id: @driver, driver: { address: @driver.address, average_rating: @driver.average_rating, city: @driver.city, company_name: @driver.company_name, dob: @driver.dob, first_name: @driver.first_name, height: @driver.height, last_name: @driver.last_name, license: @driver.license, middle_name: @driver.middle_name, owner: @driver.owner, permit_expiration_date: @driver.permit_expiration_date, permit_number: @driver.permit_number, phone_number: @driver.phone_number, physical_expiration_date: @driver.physical_expiration_date, race: @driver.race, sex: @driver.sex, state: @driver.state, status: @driver.status, total_ratings: @driver.total_ratings, training_completion_date: @driver.training_completion_date, type_id: @driver.type_id, valid: @driver.valid, weight: @driver.weight, zipcode: @driver.zipcode }
    assert_redirected_to driver_path(assigns(:driver))
  end

  test "should destroy driver" do
    assert_difference('Driver.count', -1) do
      delete :destroy, id: @driver
    end

    assert_redirected_to drivers_path
  end
end
