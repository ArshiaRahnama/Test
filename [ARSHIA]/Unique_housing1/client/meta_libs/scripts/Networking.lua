NetworkControl = function(netId)
  while not NetworkHasControlOfNetworkId(netId) do
    NetworkRequestControlOfNetworkId(netId)
    Wait(1)
  end
end

NetworkEntity = function(entity)
  while not NetworkGetEntityIsNetworked(entity) do
    NetworkRegisterEntityAsNetworked(entity)
    Wait(1)
  end
end

exports('NetworkEntity', function(...) NetworkEntity(...); end)
exports('NetworkControl', function(...) NetworkControl(...); end)