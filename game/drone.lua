drone = {
   
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
   lock_frames = 2,
   off_screen = false,

   timer = 0,

   sprite_x = 56,
   sprite_y = 0,
   sprite_w = 16,
   sprite_h = 8,

   width = 0.4,
   height = 0.2,
   depth = 0.4,

   type = "drone",

   new = function(self, new_enemy)

      setmetatable(new_enemy, {__index = self})

      return new_enemy

   end,

   update = function(self)
         
      self.z -= (0.1 * game_world.speed_factor)
      self.timer += 1

      if self.z < 2 then
         self.off_screen = true
      end

      -- check if reticle is in horizontal and vertical bounds and if targetting button is being held
      -- WRONG: bounds checking will give false positive in corners of box, beyond perimeter of circle
      -- EXTRA WRONG: have added +/- 2 to circle radius to make lock-on more forgiving...
      if (not self.target_locked and
          abs(player.x - self.x) < self.width and
          abs(player.y - self.y) < self.height and
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
         if (game_world.bullets[i].source == "player" and
            abs(game_world.bullets[i].x - self.x) < (self.width / 2) + (game_world.bullets[i].width / 2) and
            abs(game_world.bullets[i].y - self.y) < (self.height / 2) + (game_world.bullets[i].height / 2) and
            abs(game_world.bullets[i].z - self.z) < (self.depth / 2)  + (game_world.bullets[i].depth / 2)) then
               self.destroyed = true
               del(game_world.bullets, game_world.bullets[i])
               break
         end
      end

      -- control target lock flashing
      if (self.target_locked) then self.target_timer += 1 end
      if (self.target_timer == 30) then
         self.target_timer = 0
         if (self.flash) then
            self.flash = false
         else
            self.flash = true
         end
      end

   end,

   pre_draw = function(self)

      if self.timer % 2 == 0 then
         palt(6, true)
      else
         palt(7, true)
      end

      pal(5, 0)

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
         x_increment = (player.x - self.x) / 30,
         y_increment = (player.y - self.y) / 30,
         z_increment = (player.z - self.z) / 30,
         locked = false,
         source = "enemy"
      }

   end

}