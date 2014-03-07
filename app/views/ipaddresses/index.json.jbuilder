json.array!(@ipaddresses) do |ipaddress|
  json.extract! ipaddress, :id
  json.url ipaddress_url(ipaddress, format: :json)
end
