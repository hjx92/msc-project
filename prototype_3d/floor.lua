floor = {

   -- variable used to control "scroll" of floor
   time_step = 0,

   update = function(self)
      self.time_step = (self.time_step + 0.04) % 1
   end,

   draw = function(self)

      -- draw horizon line ie horiztonal line through {0, -1, 10} in world space
      y_translate = (64 - player.y) / 64
      x_translate = (64 - player.x) / 64

      hline_y = self:project_vert({0, -3 - y_translate, 10})[2]
      rectfill(0, hline_y, 128, 128, 0)
      line(0, hline_y, 128, hline_y, 6)

      for i = 0, 10 do
         line_y = self:project_vert({0, -3 - y_translate, 10 - i - self.time_step})[2]
         line(0, line_y, 128, line_y, 6)
      end

      for i = 0, 5 do
         far_point = self:project_vert({i, -3 - y_translate, 10})
         near_point = self:project_vert({i, -3 - y_translate, 1})
         line(far_point[1] - x_translate, far_point[2], near_point[1] - x_translate, near_point[2], 6)
         line(128 - far_point[1] - x_translate, far_point[2], 128 - near_point[1] - x_translate, near_point[2], 6)
      end

   end,

   project_vert = function(self, vert3)
      return {64 + ((vert3[1] / vert3[3]) * 128), 64 - ((vert3[2] / vert3[3]) * 128)}
   end

}