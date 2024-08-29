ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

function OpenF5Menu()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'showMenu',
        items = {
            {label = 'Information', value = 'information'},
            {label = 'Portefeuille', value = 'wallet'}
        }
    })
end

RegisterNUICallback('menuAction', function(data, cb)
    print('Action received from NUI:', data.action) 
    if data.action == 'information' then
        ESX.TriggerServerCallback('myresource:getUserInfo', function(user)
            local infoElements = {
                {label = 'ID: ' .. user.id, value = nil},
                {label = 'Nom: ' .. user.lastname, value = nil},
                {label = 'Prénom: ' .. user.firstname, value = nil},
                {label = 'Job: ' .. user.job, value = nil},
                {label = 'Grade: ' .. user.jobGrade, value = nil}
            }
            SendNUIMessage({
                action = 'showSubMenu',
                items = infoElements,
                title = 'Information'
            })
        end)
    elseif data.action == 'wallet' then
        ESX.TriggerServerCallback('myresource:getUserInfo', function(user)
            local walletElements = {
                {label = 'Cash: $' .. user.money, value = nil},
                {label = 'Banque: $' .. user.bank, value = nil},
                {label = 'Argent sale: $' .. user.dirtyMoney, value = nil},
                --{label = 'Voir mon permis de connduire (a venir)', value = nil},   
                --{label = 'Montrer mon permis de connduire (a venir)', value = nil},             
                {label = 'Factures', value = 'bills'}
            }
            SendNUIMessage({
                action = 'showSubMenu',
                items = walletElements,
                title = 'Portefeuille'
            })
        end)
    elseif data.action == 'bills' then
        ESX.TriggerServerCallback('myresource:getUserInfo', function(user)
            local billsElements = {}
            if #user.bills > 0 then
                for _, bill in ipairs(user.bills) do
                    table.insert(billsElements, {label = bill.label .. ': $' .. bill.amount, value = nil})
                end
            else
                table.insert(billsElements, {label = 'Pas de factures', value = nil})
            end
            SendNUIMessage({
                action = 'showSubMenu',
                items = billsElements,
                title = 'Factures'
            })
        end)
    elseif data.action == 'close' then
        SetNuiFocus(false, false)
        SendNUIMessage({action = 'hideMenu'})
    end
    cb('ok')
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 322) then
            SetNuiFocus(false, false)
            SendNUIMessage({action = 'hideMenu'})
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(0, 166) then 
            OpenF5Menu()
        end
    end
end)
