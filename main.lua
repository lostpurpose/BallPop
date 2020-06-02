local mqtt = require "mqttLoveLibrary"

local bolas = {}
player = "player1"
local N = 100
local S = 0
local pontos = 0
local count = 0
local seed = 2
local timer = 0
local gameStart = false

local function handle(msg)
  
  if msg == "ready" then
    count = count + 1
  end
  
  if count == 2 then
    
    mqtt.sendMessage("inicia:" .. seed ..":", "midnightCircus")
    count = 0
  end
  
  if msg:sub(1, 6) == "inicia" then
    gameStart = true
    S = msg:match(":(%d):")
    
    math.randomseed(S)
    local w, h = love.graphics.getDimensions()
    for i = 1, N do
      local r = math.random(20, 70)
      local x = math.random(r, w - r)
      local y = math.random(r, h - r)
      local cor = {math.random() * 0.8, math.random() * 0.8, math.random() * 0.8}
      table.insert(bolas, {r = r ,x = x, y = y, cor = cor})
    end
    
  end
  
  if msg:sub(1, 5) == "mouse" then
    id, px, py = msg:match(":(.-):(.-):(.-):")
    
    for i = #bolas, 1, -1 do
      local d = math.sqrt((px - bolas[i].x)^2 + (py - bolas[i].y)^2)
      if d < bolas[i].r then
        
        if id == player then
          pontos = pontos + (70 - (bolas[i].r - 20))
        end
        
        table.remove(bolas, i)
        break
      end
    end
  end
end


function love.load()
  
  mqtt.start("test.mosquitto.org", "player1", "midnightCircus", handle)
  mqtt.sendMessage("ready" ,"midnightCircus")
  
  
  love.graphics.setBackgroundColor(1,1,1)
  local font = love.graphics.newFont("Arial.ttf", 24)
  text = love.graphics.newText(font, "")
  textTimer = love.graphics.newText(font, "")
  finalText = love.graphics.newText(font, "")
end

function love.mousepressed(x, y, bt)
  mqtt.sendMessage("mouse:" .. player .. ":" .. x .. ":" .. y .. ":", "midnightCircus")
end



function love.update(dt)
  mqtt.checkMessages()
  
  if gameStart == true then
    timer = timer + dt
  end
  
  if timer >= 10 then
    showScore = true
    gameStart = false
  end
  
end

function love.draw()
  if timer <= 10 then
    for i = 1, #bolas do
      love.graphics.setColor(bolas[i].cor[1], bolas[i].cor[2], bolas[i].cor[3])
      love.graphics.circle("fill", bolas[i].x, bolas[i].y, bolas[i].r)
    end
    text:set(string.format("Pontos: %.1f", pontos))
    textTimer:set(string.format("Tempo: %.0f", timer))
    finalText:set(string.format())
    love.graphics.setColor(0, 0, 0)
    love.graphics.draw(text, 660, 0)
    
    love.graphics.draw(textTimer , 350, 0)
  end
  
  if showScore then
    love.graphics.draw(text, 300,300)
  end
  
end


