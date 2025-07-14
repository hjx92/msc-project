pickup = {

   scroll_speed = 0.2,
   z = 8,
   height = 0.4,
   width = 0.4,
   dept = 0.4,
   flip_x = false,
   flip_y = false,

   new_health = function(self)

      x_rand = 0.5 - rnd(1)
      y_rand = 0.5 - rnd(1)

      health = {

         x = x_rand,
         y = y_rand,

         sprite_x = 88,
         sprite_y = 0,
         sprite_w = 8,
         sprite_h = 8,

         execute = function(self)
            if player.life < 3 then 
               player.life += 1
               sfx(5)
            else sfx(6)
            end
         end

      }

      setmetatable(health, {__index = self})
      return health

   end,

   new_lock = function(self)

      x_rand = 0.5 - rnd(1)
      y_rand = 0.5 - rnd(1)

      lock = {

         x = x_rand,
         y = y_rand,

         sprite_x = 72,
         sprite_y = 0,
         sprite_w = 8,
         sprite_h = 8,

         execute = function(self)
            if player.target_limit < 9 then
               player.target_limit += 1
               sfx(7)
            else sfx(6)
            end
         end

      }

      setmetatable(lock, {__index = self})
      return lock

   end,

   new_cooldown = function(self)

      x_rand = 0.5 - rnd(1)
      y_rand = 0.5 - rnd(1)

      cooldown = {

         x = x_rand,
         y = y_rand,

         sprite_x = 80,
         sprite_y = 0,
         sprite_w = 8,
         sprite_h = 8,

         execute = function(self)
            if player.lock_cooldown_speed < 15 then
               player.lock_cooldown_speed += 0.1
               sfx(8)
            else sfx(6)
            end
         end

      }

      setmetatable(cooldown, {__index = self})
      return cooldown

   end,

   update = function(self)
      self.z -= self.scroll_speed
   end

}