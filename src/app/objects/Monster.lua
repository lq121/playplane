-- 敌机

Monster = class("Monster", function()
	return display.newNode()
end)
function Monster:ctor() 
	self.move = nil
end

function Monster:addChildView(data)
	self.data = data 
	self.isAttack = false 
	self.sprite = display.newSprite(self.data.skin):addTo(self)
	self:setState("Normal")
	local size = self.sprite:getContentSize()
	self:setContentSize(size)
	self.time = 0
end

function Monster:setEndPoint(point)
	local  selfP = cc.p(self:getPositionX(),self:getPositionY())
	local distance = cc.pGetDistance( selfP, point )
	local time = distance * self.data.spend
	self.move = transition.moveTo(self,{x = point.x,y = point.y,time = time,onComplete = function(target)
			MonsterLayer:getInstance():popMonsterList(target)
		end})
end

function Monster:setState( state)
	if self.sprite == nil then 
		error("sprite is nil,by remove or not init!",2) 
	end
	self.data.state = state 
	if state == "Normal" then
		if self.data.normalSkin then
			transition.stopTarget(self.sprite)
			transition.playAnimationForever(self.sprite, display.newAnimation(display.newFrames(self.data.normalSkin,1,2),0.1))
		end
		elseif state == "Dead" then

              transition.stopTarget(self.sprite)
              transition.removeAction(self.move)
              transition.playAnimationOnce(self.sprite,display.newAnimation(
			display.newFrames(self.data.deadSkin,1,4), 0.15), false, self.deadComplete)
              print(self.data.skin)
              if self.data.skin == "#enemy1.png" then
              	cc.SimpleAudioEngine:getInstance():playEffect("res/audio/enemy1_down.mp3")
              	elseif self.data.skin == "#enemy2.png" then
              	cc.SimpleAudioEngine:getInstance():playEffect("res/audio/enemy2_down.mp3")
              	elseif self.data.skin == "#enemy3_n1.png" then
              	cc.SimpleAudioEngine:getInstance():playEffect("res/audio/enemy3_down.mp3")
              end
              
	end
end




function Monster:updateAttack( dt)
	if self.data.state ~= "Normal" or self.isAttack ~= true  then
     return 
	end 	
	self.time = self.time + dt 
	if self.time > 2 then
       self.time = 0
       BulletLayer:getInstance():createBullet(BulletEnum.MONSTER_BULLET,cc.p(self:getPositionY()- self:getContentSize().height/2),false)
	end
end

function Monster:resert()
	self:stopAllActions()
	self:removeAllChildren()
	self:ctor()
end

function Monster:setHurtHp(value)
	if not self.tint then
		local x = cca.tintBy(0.2, 0, -1, -1)
		self.tint = transition.execute(self.sprite,cca.seq({x,x:reverse()}),{onComplete = function (target)
              self.tint = nil
		end})
	end
	local hp = self.data.hp - value 
	print(value,hp)
	if hp <= 0 then
		self:setState("Dead")
		return true
	end
	self.data.hp = hp
	return false
end

function Monster:isCanConllision(  )
	return self.data.state == "Normal"
end

function Monster:deadComplete()
	MonsterLayer:getInstance():popMonsterList(self:getParent())
end

return Monster 