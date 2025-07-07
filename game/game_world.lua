game_world = {

   scenery = {},
   bullets = {},
   --game_objects = {},

   update = function(self)

      --[[

      if btn(0, 0) then 
         camera.x -= 0.1 end
      if btn(1, 0) then 
         camera.x += 0.1 end
      if btn(2, 0) then 
         camera.y += 0.1 end
      if btn(3, 0) then 
         camera.y -= 0.1 end

      ]]--

      player:update()
      
      -- update world scenery (ie spawn new clouds or trees based on chance, clean up off-screen scenery)
      self:manage_scenery()
      self:manage_bullets()

      if self.wave and self.wave.complete then self.wave = nil end
      if not self.wave then self.wave = wave:new() end

      self.wave:update()

      --[[
      self.game_objects = {}
      self:index_objects()

      for i = 100, 10, -1 do
         if self.game_objects[i] then
            for object in all(self.game_objects[i]) do
               object:update()
            end
         end
      end

      ]]--

   end,

   draw = function(self)

      --[[

      for i = 100, 10, -1 do
         if self.game_objects[i] then
            for object in all(self.game_objects[i]) do
               object:draw()
            end
         end
      end

      ]]--

      hline_x, hline_y = project_vert({0, -2, 15})
      rectfill(0, hline_y, 128, 128, 15)

      self:draw_objects(self.scenery)
      self.wave:draw()
      self:draw_objects(self.bullets)
      player:draw()

   end,

   manage_scenery = function(self)

      if rnd(1.1) < 1 then add(self.scenery, scenery_object:new_tree()) end
      if rnd(5) < 1 then add(self.scenery, scenery_object:new_cloud()) end

      for i = #self.scenery, 1, -1 do
         self.scenery[i]:update()
         if self.scenery[i].z <= 1 then del(self.scenery, self.scenery[i]) end
      end

   end,

   manage_bullets = function(self)

      for i = #self.bullets, 1, -1 do
         self.bullets[i]:update()
         if self.bullets[i].counter >= 30 then del(self.bullets, self.bullets[i]) end
      end

   end,

   index_objects = function(self)

      for object in all(self.scenery) do

         i = flr(object.z * 10)
         self.game_objects[i] = self.game_objects[i] or {}
         add(self.game_objects[i], object)

      end

   end,

   update_objects = function(self, table)

      for object in all(table) do
         object:update()
      end

   end,

   draw_objects = function(self, table)

      for object in all(table) do
         object:draw()
      end

   end

}