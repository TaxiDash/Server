json.array!(@ratings) do |rating|
  json.extract! rating, :id, :driver_id, :rating, :comments, :timestamp
  json.url rating_url(rating, format: :json)
end
