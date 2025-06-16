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
      enemy_particles = {},

      update = function(self)

         if (#self.enemies == 0) then self:populate_enemies() end

         for i = #self.enemies, 1, -1 do
            if (self.enemies[i].destroyed) then 
               add(self.enemy_particles, particles:new(self.enemies[i].x, self.enemies[i].y))
               del(self.enemies, self.enemies[i])
               sfx(4)
            end
         end

         for i = #self.enemy_particles, 1, - 1 do
            if (self.enemy_particles[i].counter <= 0) then del(self.enemy_particles, self.enemy_particles[i]) end
         end

         for enemy in all(self.enemies) do enemy:update() end
         for particles in all(self.enemy_particles) do particles:update() end

      end,

      draw = function(self)
         for particles in all(self.enemy_particles) do particles:draw() end
         for enemy in all(self.enemies) do enemy:draw() end
      end,

      populate_enemies = function(self)
         -- decide how many enemies to spawn
         n = flr(rnd(7)) + 1
         sep = 0.8 / (n + 1)

         for i = 1, n do
            add(self.enemies, enemy:new({world_x = (i * sep) - 0.4, world_y = (rnd(0.8)) - 0.4}))
         end
      end

   }

   scenery = {

      trees = {},
      clouds = {},

      update = function(self)

         if (rnd(6) < 1) then add(self.trees, tree:new()) end
         for i = #self.trees, 1, -1 do
            self.trees[i]:update()
            if (self.trees[i].z <= 1) then del(self.trees, self.trees[i]) end
         end

         if (rnd(36) < 1) then add(self.clouds, cloud:new()) end
         for i = #self.clouds, 1, -1 do
            self.clouds[i]:update()
            if (self.clouds[i].z <= 1) then del(self.clouds, self.clouds[i]) end
         end
      end,

      draw = function(self)
         for i = #self.trees, 1, -1 do
            self.trees[i]:draw()
         end
         for i = #self.clouds, 1, -1 do
            self.clouds[i]:draw()
         end
      end

   }

end

function _update60()

   player:update()
   floor:update()
   scenery:update()
   bullet_list:update()
   enemy_list:update()

end

function _draw()

   cls(12)

   floor:draw()
   scenery:draw()
   enemy_list:draw()
   bullet_list:draw()
   player:draw()

   print("rail shooter", 64, 10, 1)

end