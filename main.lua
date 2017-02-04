local skyColors = {
	{r = 0x64, g = 0xb5, b = 0xf6},
	{r = 0x0d, g = 0x47, b = 0xa1},
	{r = 0xff, g = 0xe0, b = 0x82},
	{r = 0x31, g = 0x1b, b = 0x92}}

math.randomseed(os.time())

local rand_col = skyColors[math.random(4)]
love.graphics.setBackgroundColor(rand_col.r, rand_col.g, rand_col.b)

fonts = {}
for i = 5, 128, 5 do
	fonts[i] = love.graphics.newFont("fonts/PressStart2P.ttf", i)
end

require "logic/images"
require "logic/items"
music = {love.sound.newSoundData("music/easy.wav")}

mode = "init"
touch = love.system.getOS() == "Android" or love.system.getOS() == "iOS"
local game
local init
local credits

function love.load()
	love.filesystem.setIdentity("gc")
	world = love.physics.newWorld(0, 5000)
	love.physics.setMeter(30)

	fetchDims()

	Object = require "logic/classic"
	require "logic/TEsound"
	require "logic/camera"
	require "logic/helper"
	require "logic/callbacks"
	require "screens/game"
	require "screens/init"
	require "screens/credits"
	require "classes/foe"
	require "classes/player"
	require "classes/wall"
	require "classes/item"

	game = Game()
	init = Init()
	credits = Credits()

	game:load()
	init:load()
	credits:load()

	TEsound.playLooping(music, "music")
	TEsound.pause("music")
	
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)
	
	hiscore = love.filesystem.read("hiscore")
end

function love.update(dt)
	game:update(dt)

	if mode == "init" then
		init:update(dt)
	end
	
	if objects.player.dead then
		game:load()
	end

	TEsound.cleanup()
end

function love.draw()
	game:draw()

	if mode == "init" then
		init:draw()
	elseif mode == "credits" then
		credits:draw()
	end
end

function love.keypressed(key, code, rep)
	objects.player:keypressed(key, code, rep)
	if mode == "init" and key ~= "unknown" then
		if key == "escape" then
			local storey = objects.player:storey()
			if not hiscore or storey > tonumber(hiscore) then
				love.filesystem.write("hiscore", storey)
				hiscore = storey
				print(love.filesystem.getSaveDirectory())
			end
			love.event.quit()
		end

		if key == "left" or key == "right" then
			objects.player.gender = not objects.player.gender
			return
		end

		TEsound.resume("music")
		mode = "play"
	elseif mode == "credits" then
		mode = "init"
	elseif mode == "play" then
		if key == "escape" then
			mode = "init"
			TEsound.pause("music")
		end
	end
end

function love.keyreleased(key, code, rep)
	objects.player:keyreleased(key, code, rep)
end

function love.touchpressed(id, x, y, dx, dy, p)
	objects.player:touchpressed(x, y)
	if mode == "init" then
		init:touchpressed(x, y)
	end
end

function love.touchreleased(id, x, y, dx, dy, p)
	objects.player:touchreleased(x, y)
end


function love.mousepressed(x, y, b, t)
	if mode == "init" then
		init:mousepressed(x, y, b, t)
	end
end

function fetchDims()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
end
