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

require "images"
require "items"
music = {love.sound.newSoundData("music/easy.wav")}

mode = "init"
touch = love.system.getOS() == "Android" or love.system.getOS() == "iOS"
local game
local init

function love.load()
	love.filesystem.setIdentity("gc")
	world = love.physics.newWorld(0, 5000)

	fetchDims()

	Object = require "classic"
	require "TEsound"
	require "game"
	require "foe"
	require "player"
	require "init"
	require "wall"
	require "camera"
	require "helper"
	require "callbacks"
	require "item"

	game = Game()
	init = Init()

	game:load()
	init:load()

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
end

function fetchDims()
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
end
