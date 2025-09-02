player = {

   -- game systems data
   z = 2,

   width = 0.5,
   height = 0.0625,
   depth = 0.5,

   speed  = 0.1,
   radius = 2,
   colour = 9,
   life = 3,

   holding_fire = false,
   has_targets = false,
   targets = {},
   lock_cooldown = 0,
   lock_cooldown_speed = 1,
   target_limit = 1,
   fire_cooldown = 20,

   recently_hit = false,
   recently_hit_timer = 0,

   score = 0,
   timer = 0,

   -- 3D rendering data
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
      {1, 2, 5, 6, true},
      {2, 6, 5, 6, true},
      {1, 5, 3, 6, true},
      {2, 4, 6, 6, true},

      -- BOTTOM SIDE
      {2, 1, 7, 5, true},
      {2, 7, 8, 5, true},
      {1, 3, 7, 5, true},
      {2, 8, 4, 5, true},

      -- REAR SIDE
      {3, 5, 7, 6, true},
      {5, 6, 7, 6, true},
      {6, 8, 7, 6, true},
      {6, 4, 8, 6, true}
   },

   rotation = {0, 0, 0},
   current_vertices = {},
   flip_thruster_x = false,
   flip_thurster_y = false,
   scale = 0.25,
   angle = 0.25,

   update = function(self)

      self.timer += 1
      if self.fire_cooldown < 20 then self.fire_cooldown += 1 end

      if (self.lock_cooldown > 0) then self.lock_cooldown -= 1 end

      -- handle direction inputs
      self:input()

      self.x, self.z = self:calculate_x_z()

      -- handle firing inputs
      if (btn(4, 0) or btn(5, 0)) then
         self.holding_fire = true
      end

      if (not (btn(4, 0) or btn(5, 0)) and self.holding_fire and not self.has_targets) then
         self.holding_fire = false
         if self.fire_cooldown >= 20 then
            self.fire_cooldown = 0
            add(game_world.bullets, bullet:new(self:bullet_instructions(false)))
            sfx(3)
         end
      end

      if (not (btn(4, 0) or btn(5, 0)) and self.holding_fire and self.has_targets) then
         self.holding_fire = false
         for i = #self.targets, 1, -1 do
            self.targets[i].target_locked = false
            new_bullet = bullet:new(self:bullet_instructions(true))
            new_bullet.target = self.targets[i]
            --new_bullet.x_increment = (self.targets[i].x - self.sprite_x) / 30
            --new_bullet.y_increment = (self.targets[i].y - self.sprite_y) / 30
            add(game_world.bullets, new_bullet)
            del(self.targets, self.targets[i])
         end
         sfx(3)
         self.has_targets = false
         self.lock_cooldown = 60
      end


      --TO DO: ADD "IMMUNITY" PERIOD ON BEING HIT
      if self.recently_hit then
         self.recently_hit_timer += 1
         if self.recently_hit_timer > 60 then
            self.recently_hit_timer = 0
            self.recently_hit = false
         end
      end

      for i = #game_world.bullets, 1, -1 do
         if (game_world.bullets[i].source == "enemy" and not self.recently_hit and collides(game_world.bullets[i], self)) then
               self.life -= 1
               self.recently_hit = true
               del(game_world.bullets, game_world.bullets[i])
               sfx(4)
               break
         end
      end

      for i = #game_world.wave.enemies, 1, -1 do
         if (not self.recently_hit and collides(game_world.wave.enemies[i], self)) then
               self.life -= 1
               self.recently_hit = true
               game_world.wave.enemies[i].destroyed = true
               sfx(4)
         end
      end

      for i = #game_world.pickups, 1, -1 do
         if (not self.recently_hit and collides(game_world.pickups[i], self)) then
               game_world.pickups[i]:execute()
               del(game_world.pickups, game_world.pickups[i])
         end
      end

   end,

   pre_draw = function(self)

      -- DRAW RETICLE
      on_enemy = false

      for enemy in all(game_world.wave.enemies) do
         if abs(self.x - enemy.x) < (enemy.width / 2) and abs(self.y - enemy.y) < (enemy.height / 2) and not on_enemy then
            on_enemy = true
            rot_x, rot_y, rot_z = boss_mode_rotate({enemy.x, enemy.y, enemy.z}, game_world.rotation)
            x, y = project_vert({rot_x, rot_y, rot_z})
            line(x - 2, y, x + 2, y, 9)
            line(x, y - 2, x, y + 2, 9)
         end
      end

      if not on_enemy then 
         rot_x, rot_y, rot_z = boss_mode_rotate({self.x, self.y, self.z}, game_world.rotation)
         x, y = project_vert({rot_x, rot_y, rot_z + 3})
         line(x - 1, y, x + 1, y, 9)
         line(x, y - 1, x, y + 1, 9)
      end


      -- DRAW COCKPIT
      rear1 = {}
      rear2 = {}

      -- find cockpit
      rear1[1], rear1[2] = project_vert(self.current_vertices[5])
      rear2[1], rear2[2] = project_vert(self.current_vertices[6])
      -- set cockpit size to x-dimension width between the two topmost rear points of the ship
      cockpit_size = abs(rear1[1] - rear2[1])
      -- draw cockpit first if cockpit is above eye level (ie it should be partially occuluded by the rear of the ship)
      if (self.y > 0) then
         sspr(40, 0, 16, 16, rear1[1], max(rear1[2], rear2[2]) - cockpit_size, cockpit_size, cockpit_size)
      end

   end,

   post_draw = function(self)

      rear1 = {}
      rear2 = {}

      -- find cockpit
      rear1[1], rear1[2] = project_vert(self.current_vertices[5])
      rear2[1], rear2[2] = project_vert(self.current_vertices[6])
      -- set cockpit size to x-dimension width between the two topmost rear points of the ship
      cockpit_size = abs(rear1[1] - rear2[1])
      -- alternative draw position for the cockpit
      if (self.y <= 0) then
         sspr(40, 0, 16, 16, rear1[1], max(rear1[2], rear2[2]) - cockpit_size, cockpit_size, cockpit_size)
      end

      -- find location of "thrusters" and draw sprite
      row_ends = {}
      point1 = {}
      point2 = {}
      point3 = {}

      for i = 0, 1 do
         point1[1], point1[2] = project_vert(self.current_vertices[3 + i])
         point2[1], point2[2] = project_vert(self.current_vertices[5 + i])
         point3[1], point3[2] = project_vert(self.current_vertices[7 + i])
         thruster_x = (point1[1] + point2[1] + point3[1]) / 3
         thruster_y = (point1[2] + point2[2] + point3[2]) / 3
         add(row_ends, {thruster_x, thruster_y})
      end

      x_dif = (row_ends[1][1] - row_ends[2][1]) / 3
      y_dif = (row_ends[1][2] - row_ends[2][2]) / 3
      size = 9

      if self.timer > 2 then
         if rnd(2) < 1 then
            self.flip_thruster_x = not self.flip_thruster_x
         else
            self.flip_thurster_y = not self.flip_thurster_y
         end
         self.timer = 0
      end

      pal(9, 1)
      pal(8, 12)
      for i = 0, 3 do
         sspr(24, 0, 16, 16, (thruster_x + (x_dif * i)) - (size / 2), (thruster_y + (y_dif * i)) - (size / 2), size, size, self.flip_thruster_x, self.flip_thurster_y)
      end
      pal()

   end,

   bullet_instructions = function(self, locked_bool)

      return {
         x = self.x,
         y = self.y,
         z = self.z,
         x_increment = 0,
         y_increment = 0,
         z_increment = 0.2,
         locked = locked_bool,
         source = "player"
      }
   
   end,

   input = function(self)

      normalised_angle = self.angle - 0.25
      diff_from_world = normalised_angle - game_world.rotation

      -- MAGIC NUMBERS: ~0.07 DEGREES IS THE FIELD OF VIEW OF A CAMERA WITH FOCAL LENGTH 1 AND SCREEN HEIGHT AND WIDTH OF 1

      if (btn(0, 0) and diff_from_world < 0.06) then
         self.angle += 0.005
         self.rotation[2] -= 0.005
         --self.rotation[1] += 0.002
         --camera.x -= 0.03
      end
      if (btn(0, 0) and diff_from_world >= 0.06 and game_world.mode == "boss") then
         self.rotation[2] -= 0.005
         self.angle += 0.005
         game_world.rotation += 0.005 end   


      if (btn(1, 0) and diff_from_world > -0.06) then
         self.angle -= 0.005
         self.rotation[2] += 0.005
         --self.rotation[1] -= 0.002
         --camera.x += 0.03
      end
      if (btn(1, 0) and diff_from_world <= -0.06 and game_world.mode == "boss") then
         self.rotation[2] += 0.005
         self.angle -= 0.005
         game_world.rotation -= 0.005 end 


      if (btn(2, 0) and self.y < 1) then
         self.y += self.speed
         self.rotation[3] -= 0.001
         camera.y += 0.03 end
      if (btn(3, 0) and self.y > -1) then
         self.y -= self.speed
         self.rotation[3] += 0.001
         camera.y -= 0.03 end

   end,

   calculate_x_z = function(self)

      radius = 3

      x = radius * cos(self.angle)
      z = radius * sin(self.angle)

      z += 5

      return x, z

   end
}