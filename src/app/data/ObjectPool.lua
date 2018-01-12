ObjectPool = {}

function ObjectPool:new(type,max)
	max = max or 20

	local objectPool = {}
	objectPool.pool = {}

	function objectPool:pushPool( target )
		if max > #self.pool then
			table.insert(self.pool,target)
			target:resert()
			target:setVisible(false)
		else
			target:removeFromParent()
		end
	end

	function objectPool:getTargetForPool()
		local len = #self.pool
		if(len <= 0)then
			return type.new()
		end
		local target = table.remove(self.pool)
		target:setVisible(true)
		return target
	end
	return objectPool
end