json.array!(@rides) do |ride|
  json.extract! ride, :id, :driver_id, :rider_id, :start, :end, :estimated_fare, :actual_fare
  json.url ride_url(ride, format: :json)
end
