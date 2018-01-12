-- 创建敌机layer 

MonsterLayer = class("MonsterLayer", function()
	return display.newLayer()
end)

function MonsterLayer:getInstance()
	if _G[MonsterLayer] then
		return _G[MonsterLayer]
	end

	local monsterLayer = MonsterLayer.new()
	_G[MonsterLayer] = monsterLayer

	monsterLayer.monsterList = {}
	monsterLayer.monsterPool = ObjectPool:new(Monster,30)

	local time = 0

	function monsterLayer:pushMonsterList( target )
		table.insert(self.monsterList,target)
	end

	function monsterLayer:popMonsterList( target )
		local index = 1
		for k,v in pairs(self.monsterList) do
			if v == target then
				self.monsterPool:pushPool(table.remove(self.monsterList,index))
				break
			end
			index = index + 1
		end
	end

	function monsterLayer:createOneMonster()
		local startPos = cc.p(display.right * math.random(),display.top)
		local  endPos = cc.p(display.right * math.random(),display.bottom)
		if HeroLayer:getInstance():isHeroShow() then
			endPos.x = HeroLayer:getInstance():getHeroPosition().x - 50 + 100 * math.random()
		end
		self:createMonster(startPos,endPos)
	end

	function monsterLayer:createBossMonster()
		local startPos = cc.p(display.right*math.random(),display.top)
		local endPos = cc.p( display.right*math.random(),display.bottom )
		self:createMonster( cc.p(startPos.x,startPos.y),endPos,ObjectModel:getMonsterBossData() )
	end
	function monsterLayer:createBigMonster()
		local startPos = cc.p(display.right*math.random(),display.top)
		local endPos = cc.p(display.right * math.random(),display.bottom)
		self:createMonster(startPos,endPos,ObjectModel:getMonsterBigData())
	end

	function monsterLayer:createTriangleQueue(count)
		local startPos = cc.p(display.cx,display.top)
		local endPos = cc.p( display.right*math.random(),display.bottom )
		self:createTriangleQueueToPoint( count,startPos,endPos)
	end

	function monsterLayer:createMonster(startPos,endPos,data)
		data = data or ObjectModel:getMonsterData()
		local monster = self.monsterPool:getTargetForPool()
		if monster:getParent() == nil then
			self:addChild(monster)
		end
		self:pushMonsterList(monster)
		monster:addChildView(data)
		monster:setPosition(startPos)
		monster:setEndPoint(endPos)
		monster.isAttcak = math.random() * 10 > 8
		return monster
	end

	function monsterLayer:createTriangleQueueToPoint( count ,startPos,endPos)
	count = count or 3

	self:createMonster(startPos,endPos)

	for  i = 1,count do
		local value = cc.pMul({x = 30,y = 50},i)
		self:createMonster(cc.p(startPos.x - value.x,startPos.y+value.y),cc.p(endPos.x - value.x,endPos.y))
		self:createMonster(cc.p(startPos.x + value.x,startPos.y+value.y),cc.p(endPos.x + value.x,endPos.y))
	end
	end

	function monsterLayer:createQueue(count )
		local startPos = cc.p(display.right*math.random(),display.top)
		local endPos = cc.p( display.right*math.random(),display.bottom )
		local value = 100
		count = count or 5
		for i=1,count do
			self:createMonster( cc.p(startPos.x,startPos.y+value),endPos,ObjectModel:getQuickMonsterData() )
			value = value+100
		end
	end

	function monsterLayer:updateLayer(dt)
		time = time +dt 
		local num = math.random() * 10
		local count = #self.monsterList
		if time > 1.6 and count < 15 and num > 8 then
			if num > 9.9 then
				self:createBossMonster()
			elseif num > 9 then
				self:createTriangleQueue()
				elseif num > 8.8 then
				self:createQueue()
				elseif num > 8.5 then
					self:createBigMonster()
				else
					self:createOneMonster()
			end
		end

	for k,v in pairs(self.monsterList) do
		if k == nil then
			error("monsterList key is nil")
			break
		end
		if v == nil then
			error("monsterList value is nil")
			break
		end
		v:updateAttack(dt)
	end

	end

	return monsterLayer

end

return MonsterLayer