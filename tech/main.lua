function _init()

   cube_no = 1

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

         -- TODO: handle cases where divisor is zero...

         new_tri.short_inc_1 = (new_tri.b[1] - new_tri.a[1]) / (new_tri.b[2] - new_tri.a[2])
         new_tri.short_inc_2 = (new_tri.c[1] - new_tri.b[1]) / (new_tri.c[2] - new_tri.b[2])
         new_tri.long_inc    = (new_tri.c[1] - new_tri.a[1]) / (new_tri.c[2] - new_tri.a[2])
         return new_tri

      end,

      draw = function(self)

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

      end,

   }

   cube = {

      new = function(self, x, y, z)

         new_cube = {
            vertices = {
               { 1,  1,  1},
               {-1,  1,  1},
               {-1, -1,  1},
               { 1, -1,  1},
               { 1,  1, -1},
               {-1,  1, -1},
               {-1, -1, -1},
               { 1, -1, -1}
            },

            triangles = {
               {1, 2, 3, 8},
               {1, 3, 4, 8},
               {5, 1, 4, 11},
               {5, 4, 8, 11},
               {6, 5, 8, 12},
               {6, 8, 7, 12},
               {2, 6, 7, 10},
               {2, 7, 3, 10},
               {5, 6, 2, 13},
               {5, 2, 1, 13},
               {3, 7, 8, 14},
               {3, 8, 4, 14}
            },

            position = {0, 0, 0},
            rotation = {0, 0, 0},
            current_vertices = {},
            position = {x, y, z}
         }
         setmetatable(new_cube, {__index = self})
         return new_cube

      end,

      update = function(self)

         if (btn(0, 0)) then
            self.rotation[2] = (self.rotation[2] - 0.01) % 1.0 end
         if (btn(1, 0)) then
            self.rotation[2] = (self.rotation[2] + 0.01) % 1.0 end
         if (btn(2, 0)) then
            self.rotation[3] = (self.rotation[3] - 0.01) % 1.0 end
         if (btn(3, 0)) then
            self.rotation[3] = (self.rotation[3] + 0.01) % 1.0 end

         self:transform()
         --self:translate()
         self:triangle_sort()

      end,

      draw = function(self)

         -- 0.2 value is nonsense - just a quick hack to fix logic error with using 0.0 as limit for surface normal z-value (which breaks when cube is displaced from z axis)
         -- what I need to store in triangles[i][5] is whether total normal "faces" 0, 0, 0
         for i = 1, 12 do
            if self.triangles[i][6] then self:render_triangle(self.triangles[i]) end
         end

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

      rotate_x = function(self, angle)

         sinA = sin(angle)
         cosA = cos(angle)

         for i = 1, #self.vertices do
            self.vertices[i][1] = (cosA  * self.vertices[i][1]) + (sinA * self.vertices[i][3])
            self.vertices[i][3] = (-sinA * self.vertices[i][1]) + (cosA * self.vertices[i][3])
         end

      end,

      translate = function(self)

         for i = 1, #self.vertices do
            self.current_vertices[i] = {
               self.vertices[i][1] + self.position[1],
               self.vertices[i][2] + self.position[2],
               self.vertices[i][3] + self.position[3]
            }
         end

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

   --tri1 = triangle:new()
   --tri2 = triangle:new()
   --tri3 = triangle:new()

   cube1 = cube:new(4, 4, 12)
   cube2 = cube:new(-4, -4, 12)
   cube3 = cube:new(-4, 4, 12)
   cube4 = cube:new(4, -4, 12)
   cube5 = cube:new(4, 0, 12)
   cube6 = cube:new(-4, 0, 12)
   cube7 = cube:new(0, 4, 12)
   cube8 = cube:new(0, -4, 12)
   cube9 = cube:new(0, 0, 12)

   cube_list = {
      
      cubes = {cube1, cube2, cube3, cube4, cube5, cube6, cube7, cube8, cube9},

      update = function(self)

         for i = 1, 9 do
            self.cubes[i]:update()
         end

      end,

      draw = function(self)

         for i = 1, cube_no do
            self.cubes[i]:draw()
         end
      end

   }

end

function _update()

   if (btnp(4, 0) or btnp(5, 0)) then
         cube_no = (cube_no + 1) % 10
      end

   cube_list:update()

end

function _draw()

   cls(5)
   cube_list:draw()
   --tri1:draw()
   --tri2:draw()
   --tri3:draw()

end