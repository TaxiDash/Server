json.array!(@historical_data) do |data|
    json.name data['name']
    json.data data['data']
end
