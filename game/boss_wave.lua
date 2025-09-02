wave = {

   new = function(self)

      new_group = self:init_boss()
      setmetatable(new_group, {__index = self})
      return new_group

   end,

   update = function(self)

      self:class_update()

      for i = #self.enemies, 1, -1 do
         if (self.enemies[i].destroyed) then 
            add(self.enemy_explosion, explosion:new(self.enemies[i].x, self.enemies[i].y, self.enemies[i].z))
            del(self.enemies, self.enemies[i])
            player.score += 1
            sfx(4)
         end
      end

      for i = #self.enemies, 1, -1 do
         if (self.enemies[i].off_screen) then 
            del(self.enemies, self.enemies[i])
         end
      end

      for i = #self.enemy_explosion, 1, - 1 do
         if (self.enemy_explosion[i].counter <= 0) then del(self.enemy_explosion, self.enemy_explosion[i]) end
      end

      for enemy in all(self.enemies) do enemy:update() end
      for explosion in all(self.enemy_explosion) do explosion:update() end

      if (#self.enemies + #self.enemy_explosion == 0) and self.timer >= 301 then self.complete = true end

   end,

   draw = function(self)

      for explosion in all(self.enemy_explosion) do explosion:draw() end
      for enemy in all(self.enemies) do enemy:draw() end

   end,

   init_boss = function(self)

      boss_wave = {

         timer = 0,
         enemies = {},
         enemy_explosion = {},
         complete = false,

         class_update = function(self)

            
            if self.timer <= 301 then self.timer = self.timer + 1
            else self.timer = 0 end
            if self.timer % 30 == 0 and #self.enemies < 5 then
               temp = circle_template()
               temp.angle = 1 / (self.timer / 30)
               add(self.enemies, enemy:new(temp))
            end

         end

      }

      add(boss_wave.enemies, boss:new())

      return boss_wave

   end

}

circle_template = function()

   template = {

      radius = 1.8,
      angle = 0,
      x = r,
      y = 0,

      subclass_update = function(self)

         self.angle = self.angle + (0.005)
         if self.angle >= 1 then self.angle = 0 end

         self.x = self.radius * cos(self.angle)
         self.y = self.radius * sin(self.angle)

      end

   }

   return template

end