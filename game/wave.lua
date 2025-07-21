wave = {

   new = function(self)

      selector = rnd(1)

      if selector < 0.25 then
         new_group = self:init_sweep()
      else if selector < 0.5 then
         new_group = self:init_spread()
      else if selector < 0.75 then
         new_group = self:init_circle()
      else
         new_group = self:init_drones()
      end end end

      setmetatable(new_group, {__index = self})

      return new_group

   end,

   update = function(self)

      self:class_update()

      for i = #self.enemies, 1, -1 do
         if (self.enemies[i].destroyed) then 
            add(self.enemy_explosion, explosion:new(self.enemies[i].x, self.enemies[i].y, self.enemies[i].z))
            del(self.enemies, self.enemies[i])
            player.score += 1
            sfx(4)
         end
      end

      for i = #self.enemies, 1, -1 do
         if (self.enemies[i].off_screen) then 
            del(self.enemies, self.enemies[i])
         end
      end

      for i = #self.enemy_explosion, 1, - 1 do
         if (self.enemy_explosion[i].counter <= 0) then del(self.enemy_explosion, self.enemy_explosion[i]) end
      end

      for enemy in all(self.enemies) do enemy:update() end
      for explosion in all(self.enemy_explosion) do explosion:update() end

      if (#self.enemies + #self.enemy_explosion == 0) and self.timer >= 301 then self.complete = true end

   end,

   draw = function(self)

      for explosion in all(self.enemy_explosion) do explosion:draw() end
      for enemy in all(self.enemies) do enemy:draw() end

   end,

   init_sweep = function(self)
      -- decide on corner of entry
      -- set instructions for individual enemies
      --   (ie increments to move to opposite corner, world-space limits at which to "reverse")
      -- set variables to control flow of enemy spawn (ie target count, timer for next spawn etc)

      sweep = {

         timer = 0,
         enemies = {},
         enemy_explosion = {},
         complete = false,

         class_update = function(self)

            if flr(self.timer) % 60 == 0 then
               new_enemy = sweep_template()
               new_enemy.x, new_enemy.y, new_enemy.increment_x, new_enemy.increment_y = self.x, self.y, self.x_inc, self.y_inc
               add(self.enemies, enemy:new(new_enemy), 1)
            end
            if self.timer <= 301 then self.timer = self.timer + 1 end

         end

      }

      selector = rnd(4)
      if selector < 1 then
         sweep.x, sweep.y, sweep.x_inc, sweep.y_inc = 1, 1, -0.02, -0.02
      else if selector < 2 then
         sweep.x, sweep.y, sweep.x_inc, sweep.y_inc = 1, -1, -0.02, 0.02
      else if selector < 3 then
         sweep.x, sweep.y, sweep.x_inc, sweep.y_inc = -1, -1, 0.02, 0.02
      else sweep.x, sweep.y, sweep.x_inc, sweep.y_inc = -1, 1, 0.02, -0.02
      end end end

      return sweep

   end,

   init_spread = function(self)
      -- decide orientation of enemies (square? diamond? triangle?)
      -- set instructions for individual enemies
      -- spawn all enemies

      spread = {

         enemies = {},
         enemy_explosion = {},
         complete = false,
         timer = 301,

         class_update = function(self)
            return
         end

      }

      e = spread_template()
      e.x, e.min_x, e.max_x, e.increment_x, e.y, e.min_y, e.max_y, e.increment_y = 0, 0, 0, 0, 0.1, 0.1, 1, 0.01
      add(spread.enemies, enemy:new(e))

      e = spread_template()
      e.x, e.min_x, e.max_x, e.increment_x, e.y, e.min_y, e.max_y, e.increment_y = 0.1, 0.1, 1, 0.01, 0, 0, 0, 0
      add(spread.enemies, enemy:new(e))

      e = spread_template()
      e.x, e.min_x, e.max_x, e.increment_x, e.y, e.min_y, e.max_y, e.increment_y = 0, 0, 0, 0, -0.1, -1, -0.1, -0.01
      add(spread.enemies, enemy:new(e))

      e = spread_template()
      e.x, e.min_x, e.max_x, e.increment_x, e.y, e.min_y, e.max_y, e.increment_y = -0.1, -1, -0.1, -0.01, 0, 0, 0, 0
      add(spread.enemies, enemy:new(e))

      return spread

   end,

   init_circle = function(self)
      -- decide direction and magnitude of spiral
      --   should all enemies have same spiral?
      -- set variables to control flow of enemy spawn (ie target count, timer for next spawn etc)

      circle = {

         timer = 0,
         enemies = {},
         enemy_explosion = {},
         complete = false,

         class_update = function(self)

            if self.timer % 60 == 0 then add(self.enemies, enemy:new(circle_template())) end
            if self.timer <= 301 then self.timer = self.timer + 1 end

         end

      }

      return circle

   end,

   init_drones = function(self)

      drones = {

         timer = 0,
         enemies = {},
         enemy_explosion = {},
         complete = false,

         class_update = function(self)

            if self.timer % 30 == 0 then add(self.enemies, drone:new(drone_template())) end
            if self.timer <= 301 then self.timer = self.timer + 1 end

         end

      }

      return drones

   end

}

sweep_template = function()

   return {

      subclass_update = function(self)

         if (self.x <= -1 and self.increment_x < 0) or (self.x >= 1 and self.increment_x > 0) then
            self.increment_x = self.increment_x * -1
            self.increment_y = self.increment_y * -1
         end

         self.x = self.x + (self.increment_x * game_world.speed_factor)
         self.y = self.y + (self.increment_y * game_world.speed_factor)
      end

   }

end

spread_template = function()

   return {            
      
      subclass_update = function(self)

         if (self.x < self.min_x and self.increment_x < 0) or (self.x > self.max_x and self.increment_x > 0) then
            self.increment_x = self.increment_x * -1
         end
         if (self.y < self.min_y and self.increment_y < 0) or (self.y > self.max_y and self.increment_y > 0) then
            self.increment_y = self.increment_y * -1
         end

         self.x = self.x + (self.increment_x * game_world.speed_factor)
         self.y = self.y + (self.increment_y * game_world.speed_factor)

      end
   
   }

end

circle_template = function()

   r = circle_radius()

   template = {

      radius = r,
      angle = 0,
      x = r,
      y = 0,

      subclass_update = function(self)

         self.angle = self.angle + (0.005)
         if self.angle >= 1 then self.angle = 0 end

         self.x = self.radius * cos(self.angle)
         self.y = self.radius * sin(self.angle)

      end

   }

   return template

end

drone_template = function()

   template = {
      
      x = player.x,
      y = player.y

   }

   return template

end

circle_radius = function()

   return rnd(1.5)

end