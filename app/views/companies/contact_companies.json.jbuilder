json.companies do
    json.array!(@companies) do |company|
        json.extract! company, :name, :average_rating, :phone_number
    end
end
