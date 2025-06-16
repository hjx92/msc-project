enemy = {

   x = 64,
   y = 64,
   radius = 0,
   colour = 8,
   locked_colour = 2,
   target_locked = false,
   flash = false,
   destroyed = false,
   target_timer = 0,
   fired = false,
   fire_timer = 0,

   new = function(self, new_enemy)

      setmetatable(new_enemy, {__index = self})
      new_enemy.time_to_fire = flr(rnd(6)) * 30 + 60

      return new_enemy

   end,

   update = function(self)
         
      -- expand circle until it reaches radius of 4
      if (self.radius < 4) then self.radius += 0.01 end

      -- check if reticle is in horizontal and vertical bounds and if targetting button is being held
      -- WRONG: bounds checking will give false positive in corners of box, beyond perimeter of circle
      -- EXTRA WRONG: have added +/- 2 to circle radius to make lock-on more forgiving...
      if ((player.x - self.x) > -self.radius - 2 and
         (player.x - self.x) <  self.radius + 2 and
         (player.y - self.y) > -self.radius - 2 and
         (player.y - self.y) <  self.radius + 2 and
         (player.holding_fire)) then
            self.target_locked = true
            self.flash = true
            player.has_targets = true
            add(player.targets, self)

      end

      for i = #bullet_list.bullets, 1, -1 do
         if (bullet_list.bullets[i].source == "player" and
            (bullet_list.bullets[i].x - self.x) > -self.radius and
            (bullet_list.bullets[i].x - self.x) <  self.radius and
            (bullet_list.bullets[i].y - self.y) > -self.radius and
            (bullet_list.bullets[i].y - self.y) <  self.radius) then
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
         self.colour = 2
      end
      if (self.fire_timer > self.time_to_fire and not self.fired) then
         self.fired = true
         self.colour = 8
         add(bullet_list.bullets, bullet:new(self:bullet_instructions()))
      end
      if (self.fire_timer >= 240) then
         self.fired = false
         self.fire_timer = 0
      end

   end,

   draw = function(self)

      circfill(self.x, self.y, self.radius, self.colour)
      if (self.target_locked and self.flash) then circ(self.x, self.y, self.radius + 2, player.colour) end

   end,

   bullet_instructions = function(self)
         
      return {
         x = self.x,
         y = self.y,
         x_increment = (player.sprite_x - self.x) / 30,
         y_increment = (player.sprite_y - self.y) / 30,
         source = "enemy"
      }

   end

}