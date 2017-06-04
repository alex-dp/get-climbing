Credits = Object:extend()

function Credits:load()
end

function Credits:update(dt)
end

function Credits:draw()

	love.graphics.setColor(255, 255, 255, 128)
	love.graphics.rectangle("fill", 0, 0, width, height)
	love.graphics.setColor(60, 60, 60)

	love.graphics.setFont(fonts[65])
	love.graphics.printf("GET CLIMBING!", 0, height/2 - 200, width, "center")
	
	love.graphics.setFont(fonts[15])
	love.graphics.printf("CONCEPT\nCODE\nGRAPHICS", width / 4, height/2 - 50, width, "left")
	love.graphics.printf("deeepaaa", width / 4, height/2 - 50, width / 2, "right")
	
	love.graphics.printf("MUSIC", width / 4, height/2 + 10, width, "left")
	love.graphics.printf("Riccardo Ronchi", width / 4, height/2 + 10, width / 2, "right")
	
	love.graphics.printf("TEsound.lua (zlib)", width / 4, height/2 + 40, width, "left")
	love.graphics.printf("Ensayia\nTaehl", width / 4, height/2 + 40, width / 2, "right")
	
	love.graphics.printf("classic.lua (MIT)", width / 4, height/2 + 85, width, "left")
	love.graphics.printf("rix", width / 4, height/2 + 85, width / 2, "right")
	
	love.graphics.setColor(255, 255, 255)
end

function Credits:touchpressed(x, y)
	mode = "init"
end

function Credits:mousepressed(x, y)
	mode = "init"
end
