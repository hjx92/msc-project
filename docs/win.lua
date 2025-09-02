function _init()

   timer = 0
   cartdata("rail_shooter")
   top_score = dget(0)

end

function _update()

   if timer < 30 then
      timer += 1
   else
      if btn(4, 0) or btn(5, 0) then
         load("game/game.p8")
      end
   end

end

function _draw()

   cls()
   print("congratulations", 10, 16)
   print("run complete", 10, 26)

end