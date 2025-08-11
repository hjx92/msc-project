function _init()

   cartdata("rail_shooter")
   game_world.top_score = dget(0)
   
   -- set up inheritance heirarchy
   setmetatable(sprite_object, {__index = game_object})
   setmetatable(polygonal_object, {__index = game_object})

   -- tables that inherit from sprite_object
   setmetatable(scenery_object, {__index = sprite_object})
   setmetatable(enemy, {__index = sprite_object})
   setmetatable(drone, {__index = sprite_object})
   setmetatable(explosion, {__index = sprite_object})
   setmetatable(pickup, {__index = sprite_object})
   setmetatable(bullet, {__index = sprite_object})

   -- tables that inherit from polygonal_object
   setmetatable(player, {__index = polygonal_object})
   setmetatable(boss, {__index = polygonal_object})

end

function _update()

   game_world:update()
   hud:update()

end

function _draw()

   cls(12)
   game_world:draw()
   hud:draw()

end

load_scenery = function()

   scenery_count = peek4(0x8000)

   for i = 0, scenery_count - 1 do
      unpack_item(0x8004 + (i * 32))
   end

end

unpack_item = function(address)

   item = {}

   if peek4(address) == 1 then item.type = "tree" end
   if peek4(address) == 2 then item.type = "rock" end
   if peek4(address) == 3 then item.type = "cloud" end

   item.x = peek4(address + 4)
   item.y = peek4(address + 8)
   item.z = peek4(address + 12)
   item.height = peek4(address + 16)
   item.width = peek4(address + 20)

   if peek4(address + 24) == 1 then item.flip_x = true
   else item.flip_x = false
   end

   if peek4(address + 28) == 1 then item.flip_y = true
   else item.flip_y = false
   end

   add(game_world.scenery, scenery_object:load(item))

end