function _init()

   bullet_list = {

      bullets = {},

      update = function(self)
         for i = #self.bullets, 1, -1 do
            if (self.bullets[i].counter >= 30) then del(self.bullets, self.bullets[i]) end
         end
         for bullet in all(self.bullets) do bullet:update() end
      end,

      draw = function(self)
         for bullet in all(self.bullets) do bullet:draw() end
      end,

      add_bullet = function(self)
         add(self.bullets, bullet:new())
      end

   }

   enemy_list = {

      enemies = {},

      update = function(self)
         if (#self.enemies == 0) then self:populate_enemies() end
         for i = #self.enemies, 1, -1 do
            if (self.enemies[i].destroyed) then del(self.enemies, self.enemies[i]) end
         end
         for enemy in all(self.enemies) do enemy:update() end
      end,

      draw = function(self)
         for enemy in all(self.enemies) do enemy:draw() end
      end,

      populate_enemies = function(self)
         -- decide how many enemies to spawn
         n = flr(rnd(7)) + 1
         sep = 64 / (n + 1)

         for i = 1, n do
            add(self.enemies, enemy:new({x = (i * sep) + 32, y = flr(rnd(64)) + 32}))
         end
      end

   }

end

function _update60()

   player:update()
   floor:update()
   bullet_list:update()
   enemy_list:update()

end

function _draw()

   cls(12)

   floor:draw()
   enemy_list:draw()
   bullet_list:draw()
   player:draw()

   print("rail shooter", 64, 10, 7)

end