json.companies do
    json.array!(@companies) do |company|
        json.extract! company, :id, :name, :average_rating, :phone_number
    end
end
