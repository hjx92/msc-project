floor = {

   -- variable used to control "scroll" of floor
   time_step = 0,

   update = function(self)

      -- % 5 is completely arbitrary - should work out meaningful math...
      self.time_step = (self.time_step + 0.1) % 5

   end,

   draw = function(self)

      -- MAGIC NUMBER: 10 (arbitrary value to prevent floor disappearing when reticle is at y = 128 - implemented before bounding reticle to internal square)
      -- MAGIC NUMBER: 8 (arbitrary value selected by personal taste, to control perspective shift)
      horizon_height = (10 + ((player.y) / 8))
      horizon_line = 128 - horizon_height

      -- draw black backdrop for scrolling grid
      rectfill(0, horizon_line, 128, 128, 0)

      -- draw horizontal grid lines
      for i = 0, 4 do
         sep = (horizon_height / 4) + i
         line (0, horizon_line + (i * sep + self.time_step),
               128, horizon_line + (i * sep + self.time_step), 6)
      end

      -- draw fanned "vertical" grid lines
      for i = 1, 6 do
         x0 = (128 / 6) * i

         if (x0 <= 64) then x1 = x0 - ((3 - i) * 15)
         else x1 = x0 + ((i - 3) * 15)
         end

         line (x0, horizon_line, x1, 128, 6)
      end

      -- draw horizon line itself (last called so it appears "on top" if ie we use different colours for horizon and rest of grid)
      line (0, horizon_line, 128, horizon_line, 7)

   end

}