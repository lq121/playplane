-- 创建一个背景图的layer
BackgroundLayer = class("BackgroundLayer", function()
	return display.newLayer()
	end) 

function BackgroundLayer:ctor()
	self:addChildView()
	self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.updateBackground))
	self:scheduleUpdate()
end

-- 添加子控件
function BackgroundLayer:addChildView()
	self.bg1 = display.newSprite("#background.png", display.cx, display.cy):addTo(self)
	self.bg2 = display.newSprite("#background.png", display.cx, display.cy+self.bg1:getContentSize().height - 5):addTo(self)
end

-- 更新背景图片的位置
function BackgroundLayer:updateBackground(dt)
	local bg1Y = self.bg1:getPositionY() - 100 * dt 
	local bg2Y = self.bg2:getPositionY() - 100 * dt 

	local bgHeight = self.bg1:getContentSize().height 
	self.bg1:setPositionY(bg1Y)
	self.bg2:setPositionY(bg2Y)

	-- 判断是否超出屏幕
	if (bg1Y < display.cy-bgHeight) then
		self.bg1:setPositionY(bg2Y+bgHeight - 5)
		local temp = self.bg1
		self.bg1 = self.bg2
		self.bg2 = temp
	end

end



return BackgroundLayer