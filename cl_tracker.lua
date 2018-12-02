local trackedveh = nil
local deployed = false

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)
        if ( IsControlJustPressed(0,244) and IsPedInAnyVehicle(GetPlayerPed(-1)) and IsPedInAnyPoliceVehicle(GetPlayerPed(-1)) ) then
            if ( deployed == true ) then
                deployed = false
                TriggerEvent("tracker:trackerremove")
            elseif ( deployed == false ) then
                deployed = true
                TriggerEvent("tracker:trackerset")
            end
        end
    end
end)

RegisterNetEvent("tracker:trackerremove")
AddEventHandler("tracker:trackerremove", function()
    if deployed then
        deployed = false
        local plycoords = GetEntityCoords(GetPlayerPed(-1))
        SetNewWaypoint(plycoords.x + 2, plycoords.y)
        showNotification("~h~~o~Star Chase~h~: ~w~Tracker deactivated!")
    end
end)

RegisterNetEvent("tracker:trackerset")
AddEventHandler("tracker:trackerset", function()
    trackedveh = GetTrackedVeh(GetVehiclePedIsIn(GetPlayerPed(-1)))
    deployed = true
    while deployed do
        Citizen.Wait(0)
        if trackedveh ~= nil then
            if IsEntityAVehicle(trackedveh) then
                local coords = GetEntityCoords(trackedveh)
                showNotification("~o~~h~Star Chase:~h~~w~ Deployed!\n~h~Model:~h~ "..GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(trackedveh))).."\n~h~Plate:~h~ "..GetVehicleNumberPlateText(trackedveh))
                SetNewWaypoint(coords.x, coords.y)
            end
        else
            deployed = false
        end
    end
end)

function GetTrackedVeh(e)
	local coord1 = GetOffsetFromEntityInWorldCoords(e, 0.0, 1.0, 1.0)
	local coord2 = GetOffsetFromEntityInWorldCoords(e, 0.0, 25.0, 0.0)
	local rayresult = StartShapeTestCapsule(coord1, coord2, 3.0, 10, e, 7)
    local a, b, c, d, e = GetShapeTestResult(rayresult)
    if DoesEntityExist(e) then
        return e
    else 
        return nil
    end
end

function showNotification(string)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(string)
	DrawNotification(false, false)
end
