json.array!(@riders) do |rider|
  json.extract! rider, :id, :uuid
  json.url rider_url(rider, format: :json)
end
