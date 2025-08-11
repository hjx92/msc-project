function _init()

   starting = 649
   store_value(starting)
   ending = retrieve_value()

end

function _update()

end

function _draw()

   cls()
   print(ending)

end

store_value = function(num)

   poke4(0x8000, num)

end

retrieve_value = function()

   return peek4(0x8000 + 1)

end