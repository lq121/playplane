-- 子弹layer
BulletLayer = class("BulletLayer", function( )
	return display.newLayer()
end)

function BulletLayer:getInstance()
	if _G[BulletLayer] then
		return _G[BulletLayer]
	end
	local bulletLayer = BulletLayer.new()
	_G[BulletLayer] = bulletLayer

	bulletLayer.bulletList = {}
	bulletLayer.monsterBulletList = {}
	bulletLayer.boomBulletList = {}
	bulletLayer.bulletPool = ObjectPool:new(Bullet,30)

	function bulletLayer:pushBullet( target )
		if (target.bulletType == BulletEnum.HERO_BULLET) then
			table.insert(self.bulletList,target)
			elseif (target.bulletType == BulletEnum.MONSTER_BULLET) then
			table.insert(self.monsterBulletList,target)
			elseif (target.bulletType == BulletEnum.HERO_BOOM_BULLET) then
			table.insert(self.boomBulletList,target)
		end
	end

	function bulletLayer:popBullet(target,isNoPushPool)
		local index = 1
		local list = nil
		local obj = nil
		if (target.bulletType ==  BulletEnum.HERO_BULLET) then
			list = self.bulletList
			elseif target.bulletType == BulletEnum.MONSTER_BULLET then
			list = self.monsterBulletList
			elseif target.bulletType == BulletEnum.HERO_BOOM_BULLET then
			list = self.boomBulletList
			isNoPushPool = true
		end
		for k,v in pairs(list) do
			if v == target then
				obj = table.remove(list,index)
				if isNoPushPool == true then
					break
				end
				self.bulletPool:pushPool(obj)
				break
			end
			index = index + 1
		end
	end

	function bulletLayer:createBullet(type,point,isTop,count)
		count = count or 0
		if isTop then
			self:createOneBullet(type,point,point.x,display.top)
		else
			self:createOneBullet(type,point,point.x,display.bottom)
		end
		for i = 1,count do
			self:createByRotation(type,4 * i,point,isTop)
		end
	end

	function bulletLayer:createByRotation(type,angle,point,isTop)
		local posy = (isTop and display.top) or display.bottom
		local h = math.abs(posy - point.y)
		local posx = h * math.tan(math.rad(angle))
		if isTop then
			self:createOneBullet(type,point,point.x+posx,posy,angle)
			self:createOneBullet(type,point,point.x-posx,posy,-angle)
		else
			self:createOneBullet(type,point,point.x+posx,posy,-angle)
			self:createOneBullet(type,point,point.x-posx,posy,angle)
		end
	end

	function bulletLayer:createOneBullet(type,point,posx,posy,angle)
		local buttle = self.bulletPool:getTargetForPool()
		if (buttle:getParent() == nil) then
			buttle:addTo(self)
		end
		buttle.bulletType = type 
		self:pushBullet(buttle)
		buttle:setPosition(point)
		if angle then
			buttle:setRotation(angle);
		end
		buttle:setTargetPoint(cc.p(posx,posy))
		cc.SimpleAudioEngine:getInstance():playEffect("res/audio/bullet.mp3")
	end

	function bulletLayer:createBoom(point )
		local sp = BoomBullet.new():addTo(self)
		sp:setPosition(point)
		sp.buttleType = BulletEnum.HERO_BULLET
		self:pushBullet(sp)
		sp:setTargetPoint()
	end

	function bulletLayer:isBoomCollision(target,type)
		local list = self.boomBulletList
		for k,v in ipairs(list) do
			if k == nil then
				error("boomBulletList key is nil")
			end
			if v == nil then
				error("boomBulletList value is nil")
			end
			if v:isCollision(target) then
				return true 
			end
		end
		return false
	end

	function bulletLayer:isCollision(target,type)
		local list = nil 
		if( type == BulletEnum.HERO_BULLET )then
			list = self.bulletList
		elseif( type == BulletEnum.MONSTER_BULLET )then
			list = self.monsterBulletList
		end

		for k,v in ipairs(list) do
			if k == nil then
				error("list key is nil")
			end
			if v == nil then
				error("list value is nil")
			end
			if v:isCollision(target) then
				v:setDead()
				return true
			end
		end
		return false
	end

	return bulletLayer
end

return BulletLayer