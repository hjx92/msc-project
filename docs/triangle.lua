triangle = {

   new = function(self, point_a, point_b, point_c, tri_colour)

      new_tri = {
         a = point_a,
         b = point_b,
         c = point_c,
         colour = tri_colour
      }

      setmetatable(new_tri, {__index = self})

      new_tri:sort()

      -- TO DO: handle cases where divisor is zero...

      new_tri.short_inc_1 = (new_tri.b[1] - new_tri.a[1]) / (new_tri.b[2] - new_tri.a[2])
      new_tri.short_inc_2 = (new_tri.c[1] - new_tri.b[1]) / (new_tri.c[2] - new_tri.b[2])
      new_tri.long_inc    = (new_tri.c[1] - new_tri.a[1]) / (new_tri.c[2] - new_tri.a[2])
      return new_tri

   end,

   draw = function(self)

      -- TO DO: handle additional edge cases (eg bottom points are level)

      x1 = self.a[1]
      x2 = self.a[1]

      if (not (1 > abs(self.a[2] - self.b[2]))) then

         for y = self.a[2], self.b[2] do

            rectfill(x1, y, x2, y, self.colour)
            x1 += self.short_inc_1
            x2 += self.long_inc

         end

      end

      rectfill(self.b[1], self.b[2], x2, self.b[2], self.colour)
      x1 = self.b[1] + self.short_inc_2
      x2 += self.long_inc

      for y = self.b[2] + 1, self.c[2] do

         rectfill(x1, y, x2, y, self.colour)
         x1 += self.short_inc_2
         x2 += self.long_inc
            
      end

      line(self.a[1], self.a[2], self.b[1], self.b[2], 7)
      line(self.b[1], self.b[2], self.c[1], self.c[2], 7)
      line(self.c[1], self.c[2], self.a[1], self.a[2], 7)

   end,

   -- sorts vertices by y-value such that a is highest on screen, then b, then c
   sort = function(self)

      if (self.b[2] < self.a[2]) then
         temp = self.a
         self.a = self.b
         self.b = temp
      end

      if (self.c[2] < self.a[2]) then
         temp = self.a
         self.a = self.c
         self.c = temp
      end

      if (self.c[2] < self.b[2]) then
         temp = self.b
         self.b = self.c
         self.c = temp
      end

   end
}