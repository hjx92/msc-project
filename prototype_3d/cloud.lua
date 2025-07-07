cloud = {

   y = 3,
   z = 20,

   new = function(self)

      new_obstacle = {}
      setmetatable(new_obstacle, {__index = self})

      -- randomise x position in world space
      new_obstacle.x = rnd(16) - 8

      -- give random colour other than 12 (sky blue)
      -- REUNDANT now that obstacle has sprite...
      -- new_obstacle.colour = flr(rnd(15))
      -- if (new_obstacle.colour == 12) then new_obstacle.colour = 13 end

      -- give obstacle random height between 1 and 2, and proportionate width
      new_obstacle.h = (rnd(0.5)) + 1
      new_obstacle.w = new_obstacle.h * 2

      -- give chance that sprite draw is flipped to give variety - more useful with more complex asymmetric sprites
      if ((rnd(10) < 5)) then new_obstacle.xflip = true else new_obstacle.xflip = false end
      if ((rnd(10) < 5)) then new_obstacle.yflip = true else new_obstacle.yflip = false end

      return new_obstacle

   end,

   update = function(self)
      self.z -= 0.05
   end,

   draw = function(self)

      y_translate = (64 - player.y) / 128
      sx, sy = self:project_vert({self.x, self.y - y_translate, self.z})
      ex, ey = self:project_vert({self.x + self.w, self.y + self.h - y_translate, self.z})
      --rectfill(sx, sy, ex, ey, self.colour)
      sspr(8, 8, 16, 8, sx, ey, abs(sx - ex), abs(sy - ey), self.xflip, self.yflip)
      
   end,

   project_vert = function(self, vert3)
      return 64 + ((vert3[1] / vert3[3]) * 128), 64 - ((vert3[2] / vert3[3]) * 128)
   end
}