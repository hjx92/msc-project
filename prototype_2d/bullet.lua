bullet = {

   radius = 0,
   colour = 7,
   counter = 0,

   new = function(self, new_bullet)

      setmetatable(new_bullet, {__index = self})
      return new_bullet

   end,

   update = function(self)

      self.x += self.x_increment
      self.y += self.y_increment
      if (self.counter < 30) then self.counter += 1 end

   end,

   draw = function(self)

      -- NOTE: should remove self.counter check, since bullet_list now handles removal of object from _update60() scope?
      if (self.counter < 30) then circfill(self.x, self.y, self.radius, self.colour) end

   end

}