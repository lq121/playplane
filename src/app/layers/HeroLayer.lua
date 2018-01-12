-- 创建一个英雄(自己的飞机✈️)layer

HeroLayer = class("HeroLayer", function ()
     return display.newLayer()
end)



-- 创建单例
function HeroLayer:getInstance()
	if _G[HeroLayer] then
		return _G[HeroLayer]
	end
	local heroLayer = HeroLayer.new()
	_G[HeroLayer] = heroLayer
	local hero = nil
	local heroData = nil
	local time = 0
	local count = 0
	local buttleNum = 0
	-- 创建英雄
	function heroLayer:createHero()
		heroData = ObjectModel:getHeroData()
		hero = Hero.new():addTo(self)
		hero:addChildView(heroData)
		hero:setPosition(display.cx,display.cy)
	end

 	-- 大招(爆炸💥)
	function heroLayer:boomattack()
		if heroLayer.handle == nil then
			count = 0
			heroLayer.handle = scheduler.scheduleGlobal(self.touchHero,0.2)
		end
	end
	-- 更新，并且发射子弹
	function heroLayer:updateLayer(dt)
		time = time + dt
		if (time > 0.2 and self:isHeroShow()) then
			time = 0
			BulletLayer:getInstance():createBullet(BulletEnum.HERO_BULLET,cc.p(self:getHeroPosition().x,self:getHeroPosition().y+self:getHeroContentSize().height*0.5),true,buttleNum)
		end
	end

	-- 显示飞机
	function heroLayer:isHeroShow()
		return not (heroData.state == "Dead")
	end

	function heroLayer:touchHero(dt)
		if count > 20 then
			scheduler.unscheduleGlobal(heroLayer.handle)
			heroLayer.handle = nil
		else
			BulletLayer:getInstance():createBoom(cc.p(display.width*math.random(),display.cy - 100 + 400 *math.random()))
		end
		count = count + 1
	end

	function heroLayer:getHero()
		return hero
	end

	function heroLayer:getHeroPosition()
		return cc.p(hero:getPositionX(),hero:getPositionY())
	end

	function heroLayer:getHeroContentSize()
		return hero:getContentSize()
	end

	function heroLayer:isCollision(target)
		if self:isHeroCanByHit() == false then
			return
		end
		return hero:isCollision(target)
	end

	function heroLayer:isHeroCanByHit()
		if heroData.state == "Blink" then
			return false
		end
		if heroData.state == "Dead" then
			return false
		end
		return true
	end

	function heroLayer:setPower(value)
		heroData.power = value
	end

	function heroLayer:getPower()
		return heroData.power
	end

	function heroLayer:getHeroData()
		return heroData
	end

	function heroLayer:setHeroData(data)
		heroData = data 
		hero:addChildView(data)
	end

	function heroLayer:isCollision(target) 
		if self:isHeroCanByHit()== false then
			return false
		end
		return hero:isCollision(target)
	end

	function heroLayer:setHurtHp(value)
		if self:isHeroCanByHit() == false then
			return false
		end
		hero:setTint()
		local hp = heroData.hp - value 
		if hp <= 0 then
			hp = 0
			heroData.hp = 0
			hero:setState("Dead")
			return true
		end
		heroData.hp = hp 
		return false
	end

	return heroLayer
end

return HeroLayer