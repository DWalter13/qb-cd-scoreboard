local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('steamidentifier:id', function(source, steam)
    steam(GetPlayerIdentifiers(source)[1])
end)