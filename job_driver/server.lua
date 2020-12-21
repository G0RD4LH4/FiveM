local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","job_driver")

job = {}
Tunnel.bindInterface("job_driver", job)

function job.finishWork()
	local source = source
	local user_id = vRP.getUserId(source)
	local payment = math.random(5000, 6000)
	if user_id then
		vRP.giveBankMoney(user_id, payment)
		vRPclient.notifyPicture(source, "CHAR_BANK_MAZE", 1, "Motorista de Ônibus", false, "Salário: ~g~"..payment.." dólares.")
	end
end
