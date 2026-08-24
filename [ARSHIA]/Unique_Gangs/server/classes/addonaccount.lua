

function CreateGangAccount(name, owner, money, dirty_money, pay)
	local self = {}

	self.name  = name
	self.owner = owner
	self.money = money
	self.dirty_money = dirty_money
	self.pay	= pay

	self.addMoney = function(m)
		self.money = self.money + m

		self.save()

		TriggerClientEvent('gangprop:setMoney', -1, self.name, self.money)
	end

	self.removeMoney = function(m)
		self.money = self.money - m

		self.save()

		TriggerClientEvent('gangprop:setMoney', -1, self.name, self.money)
	end

	self.setDirty_Money = function(m)
		self.dirty_money = m

		self.save()

		TriggerClientEvent('gangprop:setDirty_Money', -1, self.name, self.dirty_money)
	end

	self.addDirty_Money = function(m)
		self.dirty_money = self.dirty_money + m

		self.save()

		TriggerClientEvent('gangprop:setDirty_Money', -1, self.name, self.dirty_money)
	end

	self.removeDirty_Money = function(m)
		self.dirty_money = self.dirty_money - m

		self.save()

		TriggerClientEvent('gangprop:setDirty_Money', -1, self.name, self.dirty_money)
	end

	self.save = function()
		if self.owner == nil then
			MySQL.Async.execute('UPDATE gang_account_data SET money = @money, dirty_money = @dirty_money WHERE gang_name = @gang_name',
			{
				['@gang_name']  = self.name,
				['@money']        = self.money,
				['@dirty_money']  = self.dirty_money
			})
		end
	end

	return self
end

