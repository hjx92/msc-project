enemy = {
   
   z = 10,
   colour = 8,

   locked_colour = 2,
   target_locked = false,
   locking = false,
   flash = false,
   destroyed = false,
   target_timer = 0,
   fired = false,
   fire_timer = 0,
   lock_frames = 3,
   off_screen = false,

   sprite_x = 9,
   sprite_y = 0,
   sprite_w = 14,
   sprite_h = 7,

   width = 0.7,
   height = 0.35,
   depth = 0.7,

   type = "saucer",

   new = function(self, new_enemy)

      setmetatable(new_enemy, {__index = self})
      new_enemy.time_to_fire = flr(rnd(6)) * 15 + 30

      return new_enemy

   end,

   update = function(self)

      -- check if reticle is in horizontal and vertical bounds and if targetting button is being held
      -- WRONG: bounds checking will give false positive in corners of box, beyond perimeter of circle
      -- EXTRA WRONG: have added +/- 2 to circle radius to make lock-on more forgiving...
      if (not self.target_locked and
          self:under_reticle() and
          self.z < 8 and
          #player.targets < player.target_limit and
          player.lock_cooldown <= 0 and
         (player.holding_fire)) then
            self.locking = true
            self.lock_frames -= 1
            if (self.lock_frames <= 0) then
               sfx(1)
               self.locking = false
               self.target_locked = true
               self.flash = true
               player.has_targets = true
               add(player.targets, self)
            end
      else 
         self.locking = false
         self.lock_frames = 5
      end

      for i = #game_world.bullets, 1, -1 do
         if (game_world.bullets[i].source == "player" and collides(game_world.bullets[i], self)) then
            self.destroyed = true
            del(game_world.bullets, game_world.bullets[i])
            break
         end
      end

      self:subclass_update()

      if (self.z > 4.5) then self.z -= (0.05 * game_world.speed_factor) end

      -- control target lock flashing
      self:control_flash()

      self.fire_timer = self.fire_timer + (1 * game_world.speed_factor)
      if (self.fire_timer > self.time_to_fire - 30 and self.fire_timer < self.time_to_fire) then
         self.colour = 8
      end
      if (self.fire_timer > self.time_to_fire and not self.fired) then
         self.fired = true
         self.colour = 2
         add(game_world.bullets, bullet:new(self:bullet_instructions()))
         selector = rnd(1)
         bullet1 = self:bullet_instructions()
         bullet2 = self:bullet_instructions()
         if selector < 0.25 then
            bullet1.x_increment = bullet1.x_increment * 2
            bullet2.x_increment = 0
         else if selector < 0.5 then
            bullet1.y_increment = bullet1.y_increment * 2
            bullet2.y_increment = 0
         else
            bullet1.y_increment = bullet1.y_increment * 2
            bullet1.x_increment = bullet1.x_increment * 2
            bullet2.y_increment = 0
            bullet2.x_increment = 0
         end end
         add(game_world.bullets, bullet:new(bullet1))
         add(game_world.bullets, bullet:new(bullet2))
         sfx(2)
      end
      if (self.fire_timer >= 120) then
         self.fired = false
         self.fire_timer = 0
      end

   end,

   pre_draw = function(self)

      pal(2, self.colour)

   end,

   post_draw = function(self)
      
      pal()
      x, y = project_vert({self.x, self.y, self.z})
      if (self.locking) then circ(x, y, self.width + self.lock_frames * 2, player.colour) end
      if (self.target_locked and self.flash) then circ(x, y, self.width + 2, player.colour) end

   end,

   bullet_instructions = function(self)
         
      return {
         x = self.x,
         y = self.y,
         z = self.z,
         x_increment = (player.x - self.x) / (60 / game_world.speed_factor),
         y_increment = (player.y - self.y) / (60 / game_world.speed_factor),
         z_increment = (player.z - self.z) / (60 / game_world.speed_factor),
         locked = false,
         source = "enemy"
      }

   end,

   under_reticle = function(self)

      x, y = project_vert({self.x, self.y, self.z})
      ret_x, ret_y = player:get_reticle()

      if abs(x - ret_x) < 8 and abs(y - ret_y) < 8 then return true
      else return false end

   end

}