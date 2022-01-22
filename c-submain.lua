
function OpenShopMenu(zone)
	local elements = {}
	ShopOpen = true

	for i=1, #Config.Zones[zone].Items, 1 do
		local item = Config.Zones[zone].Items[i]

		table.insert(elements, {
			label = ('%s - <span style="color: green;">%s</span>'):format(item.label, _U('shop_menu_item', ESX.Math.GroupDigits(item.price))),price = item.price,weaponName = item.item})
	end

	ESX.UI.Menu.CloseAll()
	PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop', {
		title = _U('shop_menu_title'),
		align = 'top-left',
		elements = elements
	}, function(data, menu)
		ESX.TriggerServerCallback('esx_weaponshop:buyWeapon', function(bought)
			if bought then
				DisplayBoughtScaleform(data.current.weaponName, data.current.price)
			else
				PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', false)
			end
		end, data.current.weaponName, zone)
	end, function(data, menu)
		PlaySoundFrontend(-1, 'BACK', 'HUD_AMMO_SHOP_SOUNDSET', false)
		ShopOpen = false
		menu.close()

		CurrentAction     = 'shop_menu'
		CurrentActionMsg  = _U('shop_menu_prompt')
		CurrentActionData = { zone = zone }
	end, function(data, menu)
		PlaySoundFrontend(-1, 'NAV', 'HUD_AMMO_SHOP_SOUNDSET', false)
	end)
end

function DisplayBoughtScaleform(weaponName, price)
	local scaleform = ESX.Scaleform.Utils.RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')
	local sec = 4

	BeginScaleformMovieMethod(scaleform, 'SHOW_WEAPON_PURCHASED')

	PushScaleformMovieMethodParameterString(_U('weapon_bought', ESX.Math.GroupDigits(price)))
	PushScaleformMovieMethodParameterString(ESX.GetWeaponLabel(weaponName))
	PushScaleformMovieMethodParameterInt(GetHashKey(weaponName))
	PushScaleformMovieMethodParameterString('')
	PushScaleformMovieMethodParameterInt(100)

	EndScaleformMovieMethod()

	PlaySoundFrontend(-1, 'WEAPON_PURCHASE', 'HUD_AMMO_SHOP_SOUNDSET', false)

	Citizen.CreateThread(function()
		while sec > 0 do
			Citizen.Wait(0)
			sec = sec - 0.01
	
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
		end
	end)
end

function OpenBuyLicenseMenu(zone)
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'shop_license', {
		title = _U('buy_license'),
		align = 'top-left',
		elements = {
			{label = _U('no'), value = 'no'},
			{label = _U('yes', ('<span style="color: green;">%s</span>'):format((_U('shop_menu_item', ESX.Math.GroupDigits(Config.LicensePrice))))), value = 'yes'},
		}
	}, function(data, menu)
		if data.current.value == 'yes' then
			ESX.TriggerServerCallback('esx_weaponshop:buyLicense', function(bought)
				if bought then
					menu.close()
					OpenShopMenu(zone)
				end
			end)
		end
	end, function(data, menu)
		menu.close()
	end)
end

DrawText3D = function(x,y,z,textInput,fontId,scaleX,scaleY,opacity)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
	local scale = (1/dist)*8
	local fov = (1/GetGameplayCamFov())*100
	local scale = scale*fov   
	SetTextScale(scaleX*scale, scaleY*scale)
	SetTextFont(fontId)
	SetTextProportional(1)
	SetTextColour(250, 250, 250, opacity)
	SetTextDropshadow(1, 1, 1, 1, 255)
	SetTextEdge(2, 0, 0, 0, 150)
	SetTextDropShadow()
	SetTextOutline()
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(textInput)
	SetDrawOrigin(x,y,z+2, 0)
	DrawText(0.0, 0.0)
	ClearDrawOrigin()
  end


  AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if ShopOpen then
			ESX.UI.Menu.CloseAll()
		end
	end
end)