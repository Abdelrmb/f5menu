ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('myresource:getUserInfo', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    exports.oxmysql:fetch('SELECT * FROM billing WHERE identifier = ?', {xPlayer.identifier}, function(bills)
        local user = {
            id = xPlayer.source,
            firstname = xPlayer.get('firstName'),
            lastname = xPlayer.get('lastName'),
            job = xPlayer.job.label,
            jobGrade = xPlayer.job.grade_label,
            money = xPlayer.getMoney(),
            bank = xPlayer.getAccount('bank').money,
            dirtyMoney = xPlayer.getAccount('black_money').money,
            bills = {}
        }

        for _, bill in ipairs(bills) do
            table.insert(user.bills, {
                label = bill.label,
                amount = bill.amount
            })
        end

        cb(user)
    end)
end)
