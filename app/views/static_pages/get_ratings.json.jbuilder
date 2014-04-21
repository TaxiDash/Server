json.drivers do
  json.array!(@drivers) do |driver|
    json.extract! driver, :first_name, :last_name, :avatar, :average_rating
    json.url driver_url(driver, format: :html)
  end
end

json.companies do
  json.array!(@companies) do |company|
    json.extract! company, :name, :logo, :average_rating
    json.url company_url(company, format: :html)
  end
end
