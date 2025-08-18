function _init()

   timer = 0
   cartdata("rail_shooter")
   top_score = dget(0)

end

function _update()

end

function _draw()

   cls()
   print("top score:", 10, 16)
   print(top_score, 52, 16)
   print("game over", 10, 26)

end