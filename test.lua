local function recvMsg(msg)
  if msg == ":player1:x:y:" then
    player, x, y = string.match(msg, :(.-):(.-):(.-):)
    for i = #bolas, 1, -1 do
    local d = math.sqrt((x - bolas[i].x)^2 + (y - bolas[i].y)^2)
    if d < bolas[i].r then
      pontos = pontos + R / bolas[i].r
      table.remove(bolas, i)
      break
    end
  end
  end
end


function love.mousepressed(x, y, bt)
  for i = #bolas, 1, -1 do
    local d = math.sqrt((x - bolas[i].x)^2 + (y - bolas[i].y)^2)
    if d < bolas[i].r then
      pontos = pontos + R / bolas[i].r
      table.remove(bolas, i)
      break
    end
  end
end