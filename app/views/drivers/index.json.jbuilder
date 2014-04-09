json.array!(@drivers) do |driver|
  json.extract! driver, :id, :first_name, :middle_name, :last_name, :date_of_birth, :address, :city, :state, :zipcode, :race, :sex, :height, :weight, :license, :phone_number, :training_completion_date, :permit_expiration_date, :permit_number, :status, :vehicle_owner, :company_id, :physical_expiration_date, :valid, :average_rating, :total_ratings
  json.url driver_url(driver, format: :json)
end
