
require("config")
require("cocos.init")
require("framework.init")
require("app.layers.BackgroundLayer")
require("app.layers.HeroLayer")
require("app.layers.BulletLayer")
require("app.layers.MonsterLayer")

require("app.objects.Hero")
require("app.objects.Bullet")
require("app.objects.Monster")


require("app.data.ObjectModel")
require("app.data.ObjectPool")
require("app.data.PrefixHead")

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    self:enterScene("MainScene")
end

return MyApp
