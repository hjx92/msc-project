bullet = {

   radius = 0,
   colour = 7,
   counter = 0,

   new = function(self, new_bullet)

      setmetatable(new_bullet, {__index = self})
      return new_bullet

   end,

   update = function(self)

      if self.locked then
         x_dist = self.target.x - self.x
         y_dist = self.target.y - self.y
         mag = sqrt(x_dist^2 + y_dist^2)
         if mag > 1 then
            self.x += (x_dist / mag) * 2
            self.y += (y_dist / mag) * 2
         else
            self.x += x_dist
            self.y += y_dist
            self.counter = 30
         end
      else
         self.x += self.x_increment
         self.y += self.y_increment
         if (self.counter < 30) then self.counter += 1 end
      end

   end,

   draw = function(self)

      -- NOTE: should remove self.counter check, since bullet_list now handles removal of object from _update60() scope?
      if (self.counter < 30) then circfill(self.x, self.y, self.radius, self.colour) end

   end

}