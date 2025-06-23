player_ship = {

   vertices = {
      {-0.5, 0, 1},
      {0.5, 0, 1},
      {-1, 0, -1},
      {1, 0, -1},
      {-0.5, 0.25, -1},
      {0.5, 0.25, -1},
      {-0.5, -0.25, -1},
      {0.5, -0.25, -1}
   },

   triangles = {
      -- TOP SIDE
      {1, 2, 5, 6},
      {2, 6, 5, 6},
      {1, 5, 3, 6},
      {2, 4, 6, 6},

      -- BOTTOM SIDE
      {2, 1, 7, 5},
      {2, 7, 8, 5},
      {1, 3, 7, 5},
      {2, 8, 4, 5},

      -- REAR SIDE
      {3, 5, 7, 6},
      {5, 6, 7, 6},
      {6, 8, 7, 6},
      {6, 4, 8, 6}
   },

   rotation = {0, 0, 0},
   current_vertices = {},
   position = {0, 0, 10},

   update = function(self)

      self:transform()
      self:triangle_sort()

   end,

   draw = function(self)

      -- find cockpit
      rear1 = self:project_vert(self.current_vertices[5])
      rear2 = self:project_vert(self.current_vertices[6])
      -- set cockpit size to x-dimension width between the two topmost rear points of the ship
      cockpit_size = abs(rear1[1] - rear2[1])
      -- draw cockpit first if cockpit is above eye level (ie it should be partially occuluded by the rear of the ship)
      if (self.position[2] > 0) then
         sspr(40, 0, 16, 16, rear1[1], max(rear1[2], rear2[2]) - cockpit_size, cockpit_size, cockpit_size)
      end
      

      -- draw polygonal model
      for i = 1, #self.triangles do
         if self.triangles[i][6] then self:render_triangle(self.triangles[i]) end
      end

      -- alternative draw position for the cockpit
      if (self.position[2] <= 0) then
         sspr(40, 0, 16, 16, rear1[1], max(rear1[2], rear2[2]) - cockpit_size, cockpit_size, cockpit_size)
      end

      -- find location of "thrusters" and draw sprite
      row_ends = {}

      for i = 0, 1 do
         point1 = self:project_vert(self.current_vertices[3 + i])
         point2 = self:project_vert(self.current_vertices[5 + i])
         point3 = self:project_vert(self.current_vertices[7 + i])
         thruster_x = (point1[1] + point2[1] + point3[1]) / 3
         thruster_y = (point1[2] + point2[2] + point3[2]) / 3
         add(row_ends, {thruster_x, thruster_y})
      end

      x_dif = (row_ends[1][1] - row_ends[2][1]) / 3
      y_dif = (row_ends[1][2] - row_ends[2][2]) / 3

      pal(9, 1)
      pal(8, 12)
      for i = 0, 3 do
         size = rnd(3) + 6
         sspr(24, 0, 16, 16, (thruster_x + (x_dif * i)) - (size / 2), (thruster_y + (y_dif * i)) - (size / 2), size, size)
      end
      pal()

      lock_on_hud_w = cockpit_size / 5

      for i = 0, 2 do
         rect(rear1[1] + (lock_on_hud_w * i * 2), rear1[2] + 10, rear1[1] + (lock_on_hud_w * i * 2) + lock_on_hud_w, rear1[2] + 10 + lock_on_hud_w, 9)
      end

      for i = 0, #player.targets - 1 do
         rectfill(rear1[1] + (lock_on_hud_w * i * 2), rear1[2] + 10, rear1[1] + (lock_on_hud_w * i * 2) + lock_on_hud_w, rear1[2] + 10 + lock_on_hud_w, 9)
      end

      cooldown_w = cockpit_size / 120

      rectfill(rear1[1], rear1[2] + 12 + lock_on_hud_w, rear1[1] + (cooldown_w * player.lock_cooldown), rear1[2] + 13 + lock_on_hud_w, 9)

   end,



   -- TRANSFORMATION

   transform = function(self)

      rotated_vertices = {}
      translated_vertices = {}

      for i = 1, 8 do
         rVert = self:rotate(self.vertices[i])
         add(rotated_vertices, rVert)
      end

      for i = 1, 8 do
         add(translated_vertices, {rotated_vertices[i][1] + self.position[1], rotated_vertices[i][2] + self.position[2], rotated_vertices[i][3] + self.position[3]})
      end

      self.current_vertices = translated_vertices

   end,
      
   rotate = function(self, vert3)

      sinA = sin(self.rotation[3])
      sinB = sin(self.rotation[2])
      sinY = sin(self.rotation[1])

      cosA = cos(self.rotation[3])
      cosB = cos(self.rotation[2])
      cosY = cos(self.rotation[1])

      x = (cosB * cosY * vert3[1]) + (((sinA * sinB * cosY) - (cosA * sinY)) * vert3[2]) + (((cosA * sinB * cosY) + (sinA * sinY)) * vert3[3])
      y = (cosB * sinY * vert3[1]) + (((sinA * sinB * sinY) + (cosA * cosY)) * vert3[2]) + (((cosA * sinB * sinY) - (sinA * cosY)) * vert3[3])
      z = (-sinB * vert3[1]) + (sinA * cosB * vert3[2]) + (cosA * cosB * vert3[3])

      return {x, y, z}

   end,

   triangle_sort = function(self)

      sorted_tris = {}

      for i = 1, #self.triangles do
         self.triangles[i][5] = self:triangle_depth(self.triangles[i])
         self.triangles[i][6] = self:triangle_facing(self.triangles[i])
      end

      for i = 1, #self.triangles do
         farthest_z = -1.1
         for i = 1, #self.triangles do
            if self.triangles[i][5] > farthest_z then
               farthest_z = self.triangles[i][5]
               winning_tri = self.triangles[i]
            end
         end
         add(sorted_tris, winning_tri)
         del(self.triangles, winning_tri)
      end

      self.triangles = sorted_tris

   end,

   triangle_depth = function(self, tri)

      return max(self.current_vertices[tri[1]][3], self.current_vertices[tri[2]][3], self.current_vertices[tri[3]][3])

   end,

   triangle_facing = function(self, tri)

      -- calculate surface normal of triangle
      ax = self.current_vertices[tri[2]][1] - self.current_vertices[tri[1]][1]
      ay = self.current_vertices[tri[2]][2] - self.current_vertices[tri[1]][2]
      az = self.current_vertices[tri[2]][3] - self.current_vertices[tri[1]][3]
      bx = self.current_vertices[tri[3]][1] - self.current_vertices[tri[1]][1]
      by = self.current_vertices[tri[3]][2] - self.current_vertices[tri[1]][2]
      bz = self.current_vertices[tri[3]][3] - self.current_vertices[tri[1]][3]

      nx = (ay * bz) - (az * by)
      ny = (az * bx) - (ax * bz)
      nz = (ax * by) - (ay * bx)

      -- original implementation to get z-component...
      -- magnitude = sqrt(nx * nx + ny * ny + nz * nz)
      -- return ((ax * by) - (ay * bx)) / magnitude

      -- calculate vector to triangle centre
      tx = (self.current_vertices[tri[1]][1] + self.current_vertices[tri[2]][1] + self.current_vertices[tri[3]][1]) / 3
      ty = (self.current_vertices[tri[1]][2] + self.current_vertices[tri[2]][2] + self.current_vertices[tri[3]][2]) / 3
      tz = (self.current_vertices[tri[1]][3] + self.current_vertices[tri[2]][3] + self.current_vertices[tri[3]][3]) / 3

      n_dot_t = (nx * tx) + (ny * ty) + (nz * tz)
      magn_magt = sqrt(nx^2 + ny^2 + nz^2) * sqrt(tx^2 + ty^2 + tz^2)
      cos_theta = n_dot_t / magn_magt

      angle = atan2(cos_theta, (-sqrt(1-(cos_theta * cos_theta))))

      if (angle < 0.25 or angle > 0.75) then return false else return true end

   end,

   -- TRIANGLE RENDERING

   render_triangle = function(self, current_tri)

      point1 = self:project_vert(self.current_vertices[current_tri[1]])
      point2 = self:project_vert(self.current_vertices[current_tri[2]])
      point3 = self:project_vert(self.current_vertices[current_tri[3]])

      tri = triangle:new(point1, point2, point3, current_tri[4])
      tri:draw()

   end,

   project_vert = function(self, vert3)

      return {64 + ((vert3[1] / vert3[3]) * 128), 64 - ((vert3[2] / vert3[3]) * 128)}

   end

}