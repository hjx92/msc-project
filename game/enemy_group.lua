enemy_group = {

   new = function(self)

      selector = rnd(1)

      if selector < 0.33 then
         new_group = self:init_sweep()
      else if selector < 0.66 then
         new_group = self:init_spread()
      else
         new_group = self:init_circle()
      end end

      setmetatable(new_group, {__index = self})

      return new_group

   end,

   update = function(self)

      self:class_update()

      for i = #self.enemies, 1, -1 do
         if (self.enemies[i].destroyed) then 
            add(self.enemy_particles, particles:new(self.enemies[i].x, self.enemies[i].y))
            del(self.enemies, self.enemies[i])
            player.score += 1
            sfx(4)
         end
      end

      for i = #self.enemy_particles, 1, - 1 do
         if (self.enemy_particles[i].counter <= 0) then del(self.enemy_particles, self.enemy_particles[i]) end
      end

      for enemy in all(self.enemies) do enemy:update() end
      for particles in all(self.enemy_particles) do particles:update() end

      if #self.enemies + #self.enemy_particles == 0 then self.complete = true end

   end,

   draw = function(self)

      for particles in all(self.enemy_particles) do particles:draw() end
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
         enemy_particles = {},
         complete = false,

         class_update = function(self)

            if flr(self.timer) % 60 == 0 then
               new_enemy = sweep_template()
               new_enemy.world_x, new_enemy.world_y, new_enemy.increment_x, new_enemy.increment_y = self.x, self.y, self.x_inc, self.y_inc
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
         enemy_particles = {},
         complete = false,

         class_update = function(self)
            return
         end

      }

      e = spread_template()
      e.world_x, e.min_x, e.max_x, e.increment_x, e.world_y, e.min_y, e.max_y, e.increment_y = 0, 0, 0, 0, 0.1, 0.1, 1, 0.01
      add(spread.enemies, enemy:new(e))

      e = spread_template()
      e.world_x, e.min_x, e.max_x, e.increment_x, e.world_y, e.min_y, e.max_y, e.increment_y = 0.1, 0.1, 1, 0.01, 0, 0, 0, 0
      add(spread.enemies, enemy:new(e))

      e = spread_template()
      e.world_x, e.min_x, e.max_x, e.increment_x, e.world_y, e.min_y, e.max_y, e.increment_y = 0, 0, 0, 0, -0.1, -1, -0.1, -0.01
      add(spread.enemies, enemy:new(e))

      e = spread_template()
      e.world_x, e.min_x, e.max_x, e.increment_x, e.world_y, e.min_y, e.max_y, e.increment_y = -0.1, -1, -0.1, -0.01, 0, 0, 0, 0
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
         enemy_particles = {},
         complete = false,

         class_update = function(self)

            if self.timer % 60 == 0 then add(self.enemies, enemy:new(circle_template())) end
            if self.timer <= 301 then self.timer = self.timer + 1 end

         end

      }

      return circle

   end

}

sweep_template = function()

   return {

      subclass_update = function(self)

         if (self.world_x <= -1 and self.increment_x < 0) or (self.world_x >= 1 and self.increment_x > 0) then
            self.increment_x = self.increment_x * -1
            self.increment_y = self.increment_y * -1
         end

         self.world_x = self.world_x + self.increment_x
         self.world_y = self.world_y + self.increment_y
      end

   }

end

spread_template = function()

   return {            
      
      subclass_update = function(self)

         if (self.world_x < self.min_x and self.increment_x < 0) or (self.world_x > self.max_x and self.increment_x > 0) then
            self.increment_x = self.increment_x * -1
         end
         if (self.world_y < self.min_y and self.increment_y < 0) or (self.world_y > self.max_y and self.increment_y > 0) then
            self.increment_y = self.increment_y * -1
         end

         self.world_x = self.world_x + self.increment_x
         self.world_y = self.world_y + self.increment_y

      end
   
   }

end

circle_template = function()

   r = circle_radius()

   template = {

      radius = r,
      angle = 0,
      world_x = r,
      world_y = 0,

      subclass_update = function(self)

         self.angle = self.angle + 0.005
         if self.angle >= 1 then self.angle = 0 end

         self.world_x = self.radius * cos(self.angle) / 3
         self.world_y = self.radius * sin(self.angle) / 3

      end

   }

   return template

end

circle_radius = function()

   return rnd(0.5)

end