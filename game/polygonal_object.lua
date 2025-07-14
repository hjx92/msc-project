polygonal_object = {
   
   draw = function(self)

      if self.recently_hit and (self.recently_hit_timer % 2 == 0) then
         return
      end

      self:transform()
      self:triangle_sort()
      
      -- opportunity for subclasses to add effects behind polygonal model (eg player cockpit in some circumstances)
      if self.pre_draw then self:pre_draw() end

      -- core polygon rendering process
      for i = 1, #self.triangles do
         if self.triangles[i][6] then self:render_triangle(self.triangles[i]) end
      end

      -- opportunity for subclasses to add effects on top of polygonal model (eg player thrusters)
      if self.post_draw then self:post_draw() end

   end,

   transform = function(self)

      rotated_vertices = {}
      translated_vertices = {}

      for i = 1, #self.vertices do
         if self.scale then
            x = self.vertices[i][1] * self.scale
            y = self.vertices[i][2] * self.scale
            z = self.vertices[i][3] * self.scale
         end
         rVert = self:rotate({x, y, z})
         add(rotated_vertices, rVert)
      end

      for i = 1, #self.vertices do
         add(translated_vertices, {rotated_vertices[i][1] + self.x, rotated_vertices[i][2] + self.y, rotated_vertices[i][3] + self.z})
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

      point1x, point1y = project_vert(self.current_vertices[current_tri[1]])
      point2x, point2y = project_vert(self.current_vertices[current_tri[2]])
      point3x, point3y = project_vert(self.current_vertices[current_tri[3]])

      tri = triangle:new({point1x, point1y}, {point2x, point2y}, {point3x, point3y}, current_tri[4])
      tri:draw()

   end

}