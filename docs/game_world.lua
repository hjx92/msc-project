game_world = {

   scenery = {},
   bullets = {},
   pickups = {},
   speed_factor = 2,
   waves = 0,

   top_score = 0,

   mode = "scrolling",

   rotation = 0,

   update = function(self)

      self:scrolling_update()

   end,

   draw = function(self)

      hline_x, hline_y = project_vert({0, -2, 15})
      rectfill(0, hline_y, 128, 128, 15)

      sorted_scene = self:sort_scene()
      for i = #sorted_scene, 1, -1 do
         sorted_scene[i]:draw()
      end

   end,

   scrolling_update = function(self)
      
      if player.life <= 0 then

         if player.score > self.top_score then
            self.top_score = player.score
         end

         dset(0, self.top_score)
         load("game/game_over.p8")

         --[[
         player.life = 3
         if player.score > self.top_score then
            self.top_score = player.score
         end
         player.score = 0
         player.lock_cooldown_speed = 1
         player.target_limit = 1
         self.speed_factor = 2
         sfx(9)

         ]]

      end

      if self.wave and self.wave.complete then
         self.wave = nil
         self.speed_factor += 0.1
         add(self.pickups, self:new_pickup())
      end
      if not self.wave then 
         if self.waves < 10 then
            self.wave = wave:new()
            self.waves += 1
         else
            store_scenery() 
            load("game/boss.p8")
         end
      end
      self.wave:update()

      player:update()
      
      self:manage_scenery()
      self:manage_bullets()
      self:manage_pickups()

   end,

   manage_scenery = function(self)

      if self.mode == "scrolling" then
         if rnd(1.1) < 1 then add(self.scenery, scenery_object:new_tree()) end
         if rnd(2) < 1 then add(self.scenery, scenery_object:new_rock()) end
         if rnd(5) < 1 then add(self.scenery, scenery_object:new_cloud()) end

         for i = #self.scenery, 1, -1 do
            self.scenery[i]:update()
            if self.scenery[i].z <= 0 then del(self.scenery, self.scenery[i]) end
         end
      end

   end,

   manage_bullets = function(self)

      for i = #self.bullets, 1, -1 do
         self.bullets[i]:update()
         if self.bullets[i].counter >= 30 or self.bullets[i].z < 2 then del(self.bullets, self.bullets[i]) end
      end

   end,

   manage_pickups = function(self)

      for i = #self.pickups, 1, -1 do
         self.pickups[i]:update()
         if self.pickups[i].z < 2 then del(self.pickups, self.pickups[i]) end
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

   end,

   sort_scene = function(self)

      scene = {}
      for object in all(self.scenery) do scene[#scene + 1] = object end
      for object in all(self.wave.enemy_explosion) do scene[#scene + 1] = object end
      for object in all(self.wave.enemies) do scene[#scene + 1] = object end
      for object in all(self.bullets) do scene[#scene + 1] = object end
      for object in all(self.pickups) do scene[#scene + 1] = object end
      -- add boss(??? should be in .wave?)
      scene[#scene + 1] = player

      for object in all(scene) do
         x, y, z = boss_mode_rotate({object.x, object.y, object.z}, game_world.rotation)
         object.dist = sqrt((x * x) + (y * y) + (z * z))
      end

      mergeSort(scene, 1, #scene)

      return scene

   end

}

mergeSort = function(A, p, r)

	if p < r then

		local q = flr((p + r)/2)
		mergeSort(A, p, q)
		mergeSort(A, q+1, r)
		merge(A, p, q, r)
      
	end

end

-- merge an array split from p-q, q-r
merge = function(A, p, q, r)

	local n1 = q-p+1
	local n2 = r-q
	local left = {}
	local right = {}
	
	for i=1, n1 do
		left[i] = A[p+i-1]
	end
	for i=1, n2 do
		right[i] = A[q+i]
	end

   x = {}
   x.dist = 32767
	
	left[n1+1] = x
	right[n2+1] = x
	
	local i=1
	local j=1
	
	for k=p, r do
		if left[i].dist<=right[j].dist then
			A[k] = left[i]
			i=i+1
		else
			A[k] = right[j]
			j=j+1
		end
	end

end

store_scenery = function()

   poke4(0x8000, #game_world.scenery)
   for i = 0, #game_world.scenery - 1 do
      obj = game_world.scenery[i + 1]
      if obj.type == "tree" then
         poke4(0x8004 + (i * 32), 1)
      end
      if obj.type == "rock" then
         poke4(0x8004  + (i * 32), 2)
      end
      if obj.type == "cloud" then
         poke4(0x8004  + (i * 32), 3)
      end
      poke4(0x8004 + (i * 32) + 4, obj.x)
      poke4(0x8004 + (i * 32) + 8, obj.y)
      poke4(0x8004 + (i * 32) + 12, obj.z)
      poke4(0x8004 + (i * 32) + 16, obj.height)
      poke4(0x8004 + (i * 32) + 20, obj.width)
      if obj.flip_x then poke4(0x8004 + (i * 32) + 24, 1)
      else poke4(0x8004 + (i * 32) + 24, 0)
      end
      if obj.flip_y then poke4(0x8004 + (i * 32) + 28, 1)
      else poke4(0x8004 + (i * 32) + 28, 0)
      end
   end

end