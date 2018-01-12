


local MainScene = class("MainScene", function()
	return display.newScene("MainScene")
	end)

function MainScene:ctor()

-- 导入plist文件和图片
display.addSpriteFrames("shoot_background.plist","shoot_background.png")
display.addSpriteFrames("shoot.plist","shoot.png")

-- 添加背景layer
BackgroundLayer:new():addTo(self)
-- 添加子弹layer
BulletLayer:getInstance():addTo(self)

-- 添加敌机
MonsterLayer:getInstance():addTo(self)

-- 添加英雄layer
HeroLayer:getInstance():addTo(self)
HeroLayer:getInstance():createHero()

-- 播放背景音乐
cc.SimpleAudioEngine:getInstance():playMusic("res/audio/game_music.mp3",true)


-- 定时发射子弹
self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, handler(self, self.updateMain))
self:scheduleUpdate()
end

function MainScene:updateMain(dt)
	HeroLayer:getInstance():updateLayer(dt)
	MonsterLayer:getInstance():updateLayer(dt)

	-- 碰撞检测回收精灵
	self:updataCollision()
end


function MainScene:updataCollision()
	local list = MonsterLayer:getInstance().monsterList
	for k,v in ipairs(list) do
		if k == nil then
			error("monsterList key is nil")
			break 
		end
		if v == nil then
			error("monsterList value is nil")
			break
		end
		if v:isCanConllision()== false then
			break
		end
		if BulletLayer:getInstance():isBoomCollision(v,BulletEnum.HERO_BOOM_BULLEF) == false then
			local isDead = false

			if BulletLayer:getInstance():isCollision(v,BulletEnum.HERO_BULLET) then
				isDead = v:setHurtHp(HeroLayer:getInstance():getPower())
			end
			if not(isDead) and HeroLayer:getInstance():isCollision(v) then
				HeroLayer:getInstance():setHurtHp(1)
			end
		else
			v:setState("Dead")
		end
	end
	if BulletLayer:getInstance():isCollision(HeroLayer:getInstance():getHero(),BulletEnum.MONSTER_BULLET) then
		HeroLayer:getInstance():setHurtHp(1)
	end
end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
