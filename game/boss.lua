boss = {

   new = function(self)
   
      new_boss = {

         width = 3.236,
         height = 3.236,
         depth = 3.236,

         scale = 0.8,

         rotation = {0, 0, 0},

         -- define regular icosahedron
         vertices = {

            -- top half
            {1, 1.618, 0},
            {-1, 1.618, 0},
            {0, 1, 1.618},
            {0, 1, -1.618},

            -- mid portion
            {1.618, 0, 1},
            {1.618, 0, -1},
            {-1.618, 0, 1},
            {-1.618, 0, -1},

            -- bottom half
            {0, -1, 1.618},
            {0, -1, -1.618},
            {1, -1.618, 0},
            {-1, -1.618, 0}

         },

         triangles = {

            {1, 2, 3, 6, true},
            {1, 4, 2, 6, true},

            {1, 6, 4, 6, true},
            {1, 5, 6, 6, true},
            {1, 3, 5, 6, true},

            {2, 4, 8, 6, true},
            {2, 8, 7, 6, true},
            {2, 7, 3, 6, true},

            {4, 6, 10, 6, false},
            {4, 10, 8, 6, true},

            {3, 7, 9, 6, true},
            {3, 9, 5, 6, true},

            {11, 10, 6, 6, true},
            {11, 6, 5, 6, true},
            {11, 5, 9, 6, true},

            {12, 8, 10, 6, true},
            {12, 7, 8, 6, true},
            {12, 9, 7, 6, true},

            {11, 12, 10, 6, true},
            {11, 9, 12, 6, true}

         }

      }

      setmetatable(new_boss, {__index = self})

      return new_boss

   end,

   update = function(self)

      if self.z > 5 then self.z -= 0.1
      else game_world.mode = "boss"
      end

      for i = #self.triangles, 1, -1 do
         for j = #game_world.bullets, 1, -1 do
            if self.triangles[i][5] then
               if self:bullet_triangle_intersect(game_world.bullets[j], self.triangles[i]) then
                  self.triangles[i][5] = false
                  add(game_world.wave.enemy_explosion, explosion:new(game_world.bullets[j].x, game_world.bullets[j].y, game_world.bullets[j].z))
                  del(game_world.bullets, game_world.bullets[j])
                  sfx(4)
               end
            end
         end
      end

   end,

   -- implementation of Möller–Trumbore intersection algorithm - https://www.graphics.cornell.edu/pubs/1997/MT97.pdf
   bullet_triangle_intersect = function(self, bullet, triangle)

      epsilon = 0.0001

      vert0 = addition(scale(self.vertices[triangle[1]], self.scale), {self.x, self.y, self.z})
      vert1 = addition(scale(self.vertices[triangle[2]], self.scale), {self.x, self.y, self.z})
      vert2 = addition(scale(self.vertices[triangle[3]], self.scale), {self.x, self.y, self.z})

      edge1 = subtract(vert1, vert0)
      edge2 = subtract(vert2, vert0)

      pvec = cross_product({bullet.x_increment, bullet.y_increment, bullet.z_increment}, edge2)

      det = dot_product(edge1, pvec)

      -- only use non-culling branch from paper, since boss shell is hollow and can be shot through
      if det > -epsilon and det < epsilon then return false end

      inv_det = 1 / det

      tvec = subtract({bullet.x, bullet.y, bullet.z}, vert0)
      u = dot_product(tvec, pvec) * inv_det
      if (u < 0 or u > 1) then return false end

      qvec = cross_product(tvec, edge1)
      v = dot_product({bullet.x_increment, bullet.y_increment, bullet.z_increment}, qvec) * inv_det
      if (v < 0 or u + v > 1) then return false end

      t = dot_product(edge2, qvec) * inv_det

      if t <= 1 then return true else return false end

   end,
}