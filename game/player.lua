player = {

   x = 64,
   y = 64,
   speed  = 1,
   radius = 2,
   colour = 9,
   life = 3,
      
   sprite_x = 64,
   sprite_y = 64,
   sprite_speed = 1.3,

   holding_fire = false,
   has_targets = false,
   targets = {},

   update = function(self)

      -- handle direction inputs, bounded by internal square for reticle
      if (btn(0, 0) and self.x > 16) then
         self.x -= self.speed
         self.sprite_x -= self.sprite_speed end
      if (btn(1, 0) and self.x < 112) then
         self.x += self.speed
         self.sprite_x += self.sprite_speed end
      if (btn(2, 0) and self.y > 16) then
         self.y -= self.speed
         self.sprite_y -= self.sprite_speed end
      if (btn(3, 0) and self.y < 112) then
         self.y += self.speed
         self.sprite_y += self.sprite_speed end

      -- handle firing inputs
      if (btn(4, 0) or btn(5, 0)) then
         self.holding_fire = true
      end
      if (not (btn(4, 0) or btn(5, 0)) and self.holding_fire and not self.has_targets) then
         self.holding_fire = false
         add(bullet_list.bullets, bullet:new(self:bullet_instructions(false)))
         sfx(3)
      end
      if (not (btn(4, 0) or btn(5, 0)) and self.holding_fire and self.has_targets) then
         self.holding_fire = false
         for i = #self.targets, 1, -1 do
            self.targets[i].target_locked = false
            new_bullet = bullet:new(self:bullet_instructions(true))
            new_bullet.target = self.targets[i]
            --new_bullet.x_increment = (self.targets[i].x - self.sprite_x) / 30
            --new_bullet.y_increment = (self.targets[i].y - self.sprite_y) / 30
            add(bullet_list.bullets, new_bullet)
            del(self.targets, self.targets[i])
         end
         sfx(3)
         self.has_targets = false
      end


      --TO DO: ADD "IMMUNITY" PERIOD ON BEING HIT

      for i = #bullet_list.bullets, 1, -1 do
         if (bullet_list.bullets[i].source == "enemy" and
            abs(bullet_list.bullets[i].x - self.sprite_x) < 4 and
            abs(bullet_list.bullets[i].y - self.sprite_y) < 6) then
               if (self.life > 0) then self.life -= 1 end
               del(bullet_list.bullets, bullet_list.bullets[i])
               break
         end
      end

   end,

   draw = function(self)

      -- draw reticle
      line(self.x - 2, self.y, self.x + 2, self.y, 9)
      line(self.x, self.y - 2, self.x, self.y + 2, 9)

      -- draw player sprite
      -- rect(self.sprite_x - 4, self.sprite_y - 6, self.sprite_x + 4, self.sprite_y + 6, 10)
      pal(5, 0)
      spr(32, self.sprite_x - 16, self.sprite_y - 8, 4, 2)

      -- draw lives
      for i = 1, self.life do
         rectfill(10 * i, 10, 10 * i + 5, 15, 8)
      end

   end,

   bullet_instructions = function(self, locked_bool, enemy)
         
      return {
         x = player.sprite_x,
         y = player.sprite_y,
         x_increment = (player.x - player.sprite_x) / 30,
         y_increment = (player.y - player.sprite_y) / 30,
         locked = locked_bool,
         source = "player"
      }
      end

}