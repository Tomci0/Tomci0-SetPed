ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterCommand('setped', function(source, args)
	if source == 0 then
		local id = args[1]

		if id then
			local tPlayer = ESX.GetPlayerFromId(id)

			if tPlayer ~= nil then
				TriggerClientEvent('Tomci0:OpenPedMenu', id)
			else
				print('Nie ma takiego gracza!')
			end
		end
	else
		local xPlayer = ESX.GetPlayerFromId(source)

		if xPlayer.group == 'moderator' or xPlayer.group == 'admin' then
			local id = args[1]

			if id then
				local tPlayer = ESX.GetPlayerFromId(id)
	
				if tPlayer ~= nil then
					TriggerClientEvent('Tomci0:OpenPedMenu', id)
				end
			else
				TriggerClientEvent('Tomci0:OpenPedMenu', source)
			end
		else
			xPlayer.showNotification('Nie posiadasz uprawnień!')
		end
	end
end)

RegisterNetEvent('Tomci0:SavePed')
AddEventHandler('Tomci0:SavePed', function(ped)

	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier1 = GetPlayerIdentifiers(_source)[2]
	local identifier = string.gsub(identifier1, "license:", "")
	local a = nil

	local a = MySQL.Sync.fetchAll("SELECT * FROM user_pedy WHERE identifier = @identifier", {
		['@identifier'] = identifier,
	});
	ped = a[1].ped
	Wait(5000)

	if ped == 'mp_m_freemode_01' or ped == 'mp_f_freemode_01' then
		if a ~= nil then
			MySQL.Async.execute("DELETE FROM user_pedy WHERE identifier = @identifier", {
				['@identifier'] = identifier,
			});
		end
	else
		if a == nil then
			MySQL.Async.execute("INSERT INTO user_pedy (identifier, ped) VALUES (@identifier, @ped)", {
				['@identifier'] = identifier,
				['@ped'] = ped,
			});
			print('es')
		else
			MySQL.Async.execute("UPDATE user_pedy SET ped=@ped WHERE identifier = @identifier", {
				['@identifier'] = identifier,
				['@ped'] = ped
			});
			print('noes')
		end
	end
end)

RegisterNetEvent('Tomci0:CheckPed')
AddEventHandler('Tomci0:CheckPed', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local identifier1 = GetPlayerIdentifiers(_source)[2]
	local identifier = string.gsub(identifier1, "license:", "")
	local a = nil

	Wait(5000)
	-- MySQL.Async.fetchAll('SELECT * FROM tomcio_peds WHERE identifier = @identifier',  {
	-- 	['@identifier'] = identifier
	-- }, function(result)
	-- 	if result[1].identifier ~= nil then
	-- 		TriggerClientEvent('Tomci0:SetPedToUser', _source, result[1].ped)
	-- 	end
	-- end)

	local a = MySQL.Sync.fetchAll("SELECT * FROM user_pedy WHERE identifier = @identifier", {
		['@identifier'] = identifier,
	});
	ped = a[1]

	if ped ~= nil then
		TriggerClientEvent('Tomci0:SetPedToUser', _source, ped.ped)
	end
end)
