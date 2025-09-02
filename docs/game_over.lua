function _init()

   timer = 0
   cartdata("rail_shooter")
   top_score = dget(0)

end

function _update()

    if (btn(4, 0) or btn(5, 0)) then
      load("game/game.p8")
    end

end

function _draw()

   cls()
   print("top score:", 5, 16)
   print(top_score, 47, 16)
   print("game over", 5, 26)
   print("press a face button to restart", 5, 46)

end