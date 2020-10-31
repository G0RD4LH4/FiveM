local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

job = {}
Tunnel.bindInterface("job_driver", job)

function job.payment(bonus)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        vRP.giveMoney(user_id,math.random(350,500)+bonus)
    end
end