json.array!(@virtualmachines) do |virtualmachine|
  json.extract! virtualmachine, :id, :label, :remoteID
  json.url virtualmachine_url(virtualmachine, format: :json)
end
