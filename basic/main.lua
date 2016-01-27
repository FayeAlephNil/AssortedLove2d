debug = true

-- Art from opengameart.org
assets = {}

-- Directions enum
directions = {
  up = -1,
  down = 1,
  left = -1,
  right = 1
}

-- Player Data
player = {
  x = love.graphics.getWidth()/2,
  y = love.graphics.getHeight()/2,
  speed = 225,
  img = nil,
  shooting = {
    canShoot = true,
    canShootTimerMax = 1,
    canShootTimer = 1
  }
}

-- Arrows
arrows = {}

tau = math.pi * 2

function love.load(arg)
  -- Blocky by Zack Alvarado from opengameart
  assets.playerImg = love.graphics.newImage('assets/player/player.png')
  assets.playerImg:setFilter("nearest", "nearest")
  player.img = assets.playerImg

  -- PlatForge project, as well as the artists: Hannah Cohan and Stafford McIntyre
  assets.arrowImg = love.graphics.newImage('assets/objects/arrow.png')

  love.graphics.setBackgroundColor(255, 255, 255)
end

function love.update(dt)
  if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

  player.y = moveInput(dt, directions.up, player.y, 'w', 'up')
  player.x = moveInput(dt, directions.left, player.x, 'a', 'left')
  player.y = moveInput(dt, directions.down, player.y, 's', 'down')
  player.x = moveInput(dt, directions.right, player.x, 'd', 'right')

  playerShooting(dt)
  updatearrows(dt)
end

function playerShooting(dt)
  local shooting = player.shooting

  shooting.canShootTimer = shooting.canShootTimer - (1 * dt)
  
  if shooting.canShootTimer <= 0 then
    shooting.canShoot = true
  end

  if love.keyboard.isDown('space', 'rctrl', 'lctrl', 'ctrl') and shooting.canShoot then
    local newArrow = {
      x = player.x + player.img:getWidth()/2,
      y = player.y,
      img = assets.arrowImg
    }
    table.insert(arrows, newArrow)
    shooting.canShoot = false
    shooting.canShootTimer = shooting.canShootTimerMax
  end
end

function updatearrows(dt)
  for i, arrow in ipairs(arrows) do
	  arrow.y = arrow.y - (250 * dt)

  	if arrow.y < 0 then
		  table.remove(arrows, i)
	  end
  end
end

function moveInput(dt, direction, start, ...)
  local result = start
  if love.keyboard.isDown(...) then
    result = movement(dt, direction, start, player.speed)
  end
  return result
end

function movement(dt, direction, start, speed)
	return start + (speed * dt * direction)
end

function love.draw(dt)
  local scale = 1
  love.graphics.scale(scale)
  love.graphics.draw(player.img, player.x, player.y, 0, 3, 3)

  for i, arrow in ipairs(arrows) do
    love.graphics.draw(arrow.img, arrow.x, arrow.y, 3 * tau/4)
  end
end
