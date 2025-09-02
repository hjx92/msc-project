boss = {

   new = function(self)
   
      new_boss = {

         width = 3.236,
         height = 3.236,
         depth = 3.236,

         scale = 0.8,

         rotation = {0, 0, 0},

         timer = 0,

         available_faces = 20,
         face_nominated = false,

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

            {1, 2, 3},
            {1, 4, 2},

            {1, 6, 4},
            {1, 5, 6},
            {1, 3, 5},

            {2, 4, 8},
            {2, 8, 7},
            {2, 7, 3},

            {4, 6, 10},
            {4, 10, 8},

            {3, 7, 9},
            {3, 9, 5},

            {11, 10, 6},
            {11, 6, 5},
            {11, 5, 9},

            {12, 8, 10},
            {12, 7, 8},
            {12, 9, 7},

            {11, 12, 10},
            {11, 9, 12}

         }

      }

      for triangle in all(new_boss.triangles) do
         triangle[4] = 6
         triangle[5] = true
         triangle[8] = false
      end

      setmetatable(new_boss, {__index = self})

      return new_boss

   end,

   update = function(self)

      if self.z > 5 then self.z -= 0.1
      else game_world.mode = "boss"
      end

      if not self.face_nominated then self:nominate_face() end

      self:transform()

      for i = #self.triangles, 1, -1 do
         for j = #game_world.bullets, 1, -1 do
            if self.triangles[i][5] and game_world.bullets[j].source == "player" then
               if self.triangles[i][8] then
                  if self:bullet_triangle_intersect(game_world.bullets[j], self.triangles[i]) then
                     self.triangles[i][5] = false
                     self.face_nominated = false
                     self.available_faces -= 1
                     add(game_world.wave.enemy_explosion, explosion:new(game_world.bullets[j].x, game_world.bullets[j].y, game_world.bullets[j].z))
                     del(game_world.bullets, game_world.bullets[j])
                     sfx(4)
                  end
               else
                  if self:bullet_triangle_intersect(game_world.bullets[j], self.triangles[i]) then
                     game_world.bullets[j].source = "enemy"
                     game_world.bullets[j].x_increment *= -1
                     game_world.bullets[j].y_increment *= -1
                     game_world.bullets[j].z_increment *= -1
                     game_world.bullets[j].x += game_world.bullets[j].x_increment
                     game_world.bullets[j].y += game_world.bullets[j].y_increment
                     game_world.bullets[j].z += game_world.bullets[j].z_increment
                     sfx(4)
                  end
               end
            end
         end
      end

      if self.timer < 301 then self.timer += 1
      else self.timer = 0 end

      if self.timer < 100 then self.rotation[1] += 0.01
      else if self.timer < 200 then self.rotation[2] += 0.01
      else self.rotation[3] += 0.01
      end end

   end,

   -- implementation of Möller–Trumbore intersection algorithm - https://www.graphics.cornell.edu/pubs/1997/MT97.pdf
   bullet_triangle_intersect = function(self, bullet, triangle)

      epsilon = 0.0001

      vert0 = self.current_vertices[triangle[1]]
      vert1 = self.current_vertices[triangle[2]]
      vert2 = self.current_vertices[triangle[3]]

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

   nominate_face = function(self)

      num = flr(rnd(self.available_faces - 1)) + 1
      count = 1

      if self.available_faces <= 0 then
         load("game/win.p8")
      end

      for i = 1, #self.triangles do
         if self.triangles[i][5] then
            if num == count then
               self.triangles[i][4] = 13
               self.triangles[i][8] = true
               count += 1
               self.face_nominated = true
            else
               count += 1
            end
         end
      end

   end
}