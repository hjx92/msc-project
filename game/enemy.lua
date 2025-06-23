enemy = {

   world_z = 10,
   radius = 0,
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

   new = function(self, new_enemy)

      setmetatable(new_enemy, {__index = self})

      y_translate = (64 - player.y) / 128
      position = self:project_vert({new_enemy.world_x, new_enemy.world_y - y_translate, new_enemy.world_z})
      
      new_enemy.x = position[1]
      new_enemy.y = position[2]
      new_enemy.time_to_fire = flr(rnd(6)) * 30 + 60

      return new_enemy

   end,

   update = function(self)
         
      -- expand circle until it reaches radius of 4
      if (self.world_z > 2.5) then self.world_z -= 0.05 end

      -- check if reticle is in horizontal and vertical bounds and if targetting button is being held
      -- WRONG: bounds checking will give false positive in corners of box, beyond perimeter of circle
      -- EXTRA WRONG: have added +/- 2 to circle radius to make lock-on more forgiving...
      if (not self.target_locked and
          abs(player.x - self.x) < self.radius + 3 and
          abs(player.y - self.y) < self.radius + 3 and
          self.world_z < 6 and
          #player.targets < 3 and
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

      for i = #bullet_list.bullets, 1, -1 do
         if (bullet_list.bullets[i].source == "player" and
            abs(bullet_list.bullets[i].x - self.x) < self.radius and
            abs(bullet_list.bullets[i].y - self.y) < self.radius) then
               self.destroyed = true
               del(bullet_list.bullets, bullet_list.bullets[i])
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

      self.fire_timer = self.fire_timer + 1
      if (self.fire_timer > self.time_to_fire - 60 and self.fire_timer < self.time_to_fire) then
         self.colour = 8
      end
      if (self.fire_timer > self.time_to_fire and not self.fired) then
         self.fired = true
         self.colour = 2
         add(bullet_list.bullets, bullet:new(self:bullet_instructions()))
         sfx(2)
      end
      if (self.fire_timer >= 240) then
         self.fired = false
         self.fire_timer = 0
      end

   end,

   draw = function(self)

      y_translate = (64 - player.y) / 128
      position = self:project_vert({self.world_x, self.world_y - y_translate, self.world_z})

      self.x = position[1]
      self.y = position[2]
      self.radius = self:project_vert({self.world_x, self.world_y - 0.04 - y_translate, self.world_z})[2] - position[2]

      --circfill(self.x, self.y, self.radius, self.colour)
      pal(2, self.colour)
      sspr(8, 0, 16, 8, self.x - self.radius * 4, self.y - self.radius * 2, self.radius * 8, self.radius * 4)
      if (self.locking) then circ(self.x, self.y, self.radius + 2 + self.lock_frames * 2, player.colour) end
      if (self.target_locked and self.flash) then circ(self.x, self.y, self.radius + 2, player.colour) end

   end,

   bullet_instructions = function(self)
         
      return {
         x = self.x,
         y = self.y,
         x_increment = (player.sprite_x - self.x) / 30,
         y_increment = (player.sprite_y - self.y) / 30,
         locked = false,
         source = "enemy"
      }

   end,

   project_vert = function(self, vert3)
      return {64 + ((vert3[1] / vert3[3]) * 128), 64 - ((vert3[2] / vert3[3]) * 128)}
   end

}