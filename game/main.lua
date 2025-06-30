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

   level = {

      enemies = enemy_group:new(),

      update = function(self)

         if (self.enemies.complete) then 
            self.enemies = enemy_group:new()
            if (player.life < 3) then
               player.life += 1
               sfx(5)
            end
         end

         self.enemies:update()

      end,

      draw = function(self)
         self.enemies:draw()
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

function _update()

   player:update()
   floor:update()
   scenery:update()
   bullet_list:update()
   level:update()

end

function _draw()

   cls(12)

   floor:draw()
   scenery:draw()
   level:draw()
   bullet_list:draw()
   player:draw()

   if (player.life <= 0) then player.score = 0 end
   print(player.score, 104, 10, 1)

end