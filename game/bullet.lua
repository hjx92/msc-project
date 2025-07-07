bullet = {

   width = 0.2,
   height = 0.2,
   depth = 0.4,
   colour = 7,
   counter = 0,

   new = function(self, new_bullet)

      setmetatable(new_bullet, {__index = self})

      new_bullet.sprite_x = 24
      new_bullet.sprite_y = 0
      new_bullet.sprite_w = 16
      new_bullet.sprite_h = 16

      return new_bullet

   end,

   update = function(self)

      if self.locked then
         if self.target.destroyed then self.counter = 30 end
         x_dist = self.target.x - self.x
         y_dist = self.target.y - self.y
         z_dist = self.target.z - self.z
         mag = sqrt(x_dist^2 + y_dist^2 + z_dist ^2)
         if mag > 1 then
            self.x += (x_dist / mag) / 10
            self.y += (y_dist / mag) / 10
            self.z += (z_dist / mag) / 10
         else
            self.x += x_dist
            self.y += y_dist
            self.z += z_dist
         end
      else
         self.x += self.x_increment
         self.y += self.y_increment
         self.z += self.z_increment
         if (self.counter < 30) then self.counter += 1 end
      end

   end,

   pre_draw = function(self)

      if self.source == "player" then pal(8, 5) end
      if self.source == "enemy" then pal(9, 5) end

   end,

   post_draw = function(self)

      pal()

   end

}