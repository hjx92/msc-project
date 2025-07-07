function _init()
   
   -- set up inheritance heirarchy
   setmetatable(sprite_object, {__index = game_object})
   setmetatable(polygonal_object, {__index = game_object})

   -- tables that inherit from sprite_object
   setmetatable(scenery_object, {__index = sprite_object})
   setmetatable(enemy, {__index = sprite_object})
   setmetatable(explosion, {__index = sprite_object})
   setmetatable(friendly, {__index = sprite_object})
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
   -- print(#game_world.scenery)

end