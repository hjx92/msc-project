game_world = {

   scenery = {},
   bullets = {},
   pickups = {},
   speed_factor = 2,

   top_score = 0,
   --game_objects = {},

   mode = "boss",

   rotation = 0,

   update = function(self)

      self:scrolling_update()

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
      self:draw_objects(self.pickups)
      player:draw()

   end,

   scrolling_update = function(self)
      
      if player.life <= 0 then
         player.life = 3
         if player.score > self.top_score then
            self.top_score = player.score
         end
         player.score = 0
         player.lock_cooldown_speed = 1
         player.target_limit = 1
         self.speed_factor = 2
         sfx(9)
      end

      if self.wave and self.wave.complete then
         self.wave = nil
         self.speed_factor += 0.1
         add(self.pickups, self:new_pickup())
      end
      if not self.wave then self.wave = wave:new() end
      self.wave:update()

      player:update()
      
      self:manage_scenery()
      self:manage_bullets()
      self:manage_pickups()

   end,

   manage_scenery = function(self)

      if rnd(1.1) < 1 then add(self.scenery, scenery_object:new_tree()) end
      if rnd(2) < 1 then add(self.scenery, scenery_object:new_rock()) end
      if rnd(5) < 1 then add(self.scenery, scenery_object:new_cloud()) end

      for i = #self.scenery, 1, -1 do
         self.scenery[i]:update()
         if self.scenery[i].z <= 0 then del(self.scenery, self.scenery[i]) end
      end

   end,

   manage_bullets = function(self)

      for i = #self.bullets, 1, -1 do
         if self.bullets[i].counter >= 30 or self.bullets[i].z < 2 then del(self.bullets, self.bullets[i]) end
      end

      for i = #self.bullets, 1, -1 do
         self.bullets[i]:update()
      end

   end,

   manage_pickups = function(self)

      for i = #self.pickups, 1, -1 do
         self.pickups[i]:update()
         if self.pickups[i].z < 2 then del(self.pickups, self.pickups[i]) end
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

      for i = 1, #table do
         table[i]:update()
      end

   end,

   draw_objects = function(self, table)

      for i = 1, #table do
         table[i]:draw()
      end

   end,

   new_pickup = function(self)

      selector = rnd(1)

      if selector < 0.33 then
         return pickup:new_cooldown()
      else if selector < 0.66 then
         return pickup:new_lock()
      else return pickup:new_health()
      end end

   end

}