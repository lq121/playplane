Bullet = class("Bullet", function ()
     return display.newNode()
end)

function Bullet:ctor()
	self.spend = 0.002
	self.sprite = display.newSprite("#bullet1.png"):addTo(self)
	self:setContentSize(self.sprite:getContentSize().width,self.sprite:getContentSize().height)
end

function Bullet:resert()
	-- body
	self:stopAllActions()
	self:setRotation(0)
	self:removeAllChildren()
	self:ctor()
end

function Bullet:setTargetPoint(point)
	local position = cc.p(self:getPositionX(),self:getPositionY())
	local distance = cc.pGetDistance(position,point)
	local time = distance * self.spend
	transition.moveTo(self, {x = point.x,y = point.y, time = time,onComplete = function (target)
     self:setDead()
	end})
end

function Bullet:setDead( )
	BulletLayer:getInstance():popBullet(self)
end


function Bullet:isCollision(target)
	local rectA = target:getBoundingBox()
	local rectB = self:getBoundingBox()
	rectA = cc.rect(rectA.x - rectA.width * 0.5, rectA.y - rectA.height * 0.5, rectA.width, rectA.height)
	rectB = cc.rect(rectB.x - rectB.width * 0.5, rectB.y - rectB.height * 0.5, rectB.width, rectB.height)
	return cc.rectIntersectsRect(rectA,rectB)
end


return Bullet