hud = {

   update = function(self)
   end,

   draw = function(self)
      
      --[[

      -- draw player health
      print("health", 10, 10, 0)
      rectfill(36, 10, 46 + (player.life * 10), 14, 8)

      ]]

      x, y, z = boss_mode_rotate({player.x, player.y, player.z}, game_world.rotation)
      hud_x, hud_y = project_vert({x, y, z - 0.1})
      rectfill(hud_x - 15, hud_y + 8, hud_x - 15 + (player.life * 10), hud_y + 10, 8)
      rectfill(hud_x - 15, hud_y + 11, hud_x + 15, hud_y + 11, 0)
      rectfill(hud_x - 15, hud_y + 12, hud_x - 15 + (player.lock_cooldown / 2), hud_y + 13, 9)

      lock_sep = 30 / (player.target_limit + 1)

      for i = 1, player.target_limit do
         circfill(hud_x - 15 + (lock_sep * i), hud_y + 15, 0, 5)
      end

      for i = 1, #player.targets do
         circfill(hud_x - 15 + (lock_sep * i), hud_y + 15, 0, 9)
      end

      --[[
      for i = 1, player.life do
         rectfill(hud_x + 16, hud_y + ((i - 1) * 4) - 10, hud_x + 18, hud_y + ((i - 1) * 4) - 8, 8)
      end

      -- draw lock counter and cooldown
      print("lock-ons:", 10, 113, 0)
      print(#player.targets, 47, 113, 0)
      print("/", 52, 113, 0)
      print(player.target_limit, 56, 113, 0)
      rectfill(62, 113, 62 + (player.lock_cooldown), 117, 9)

      ]]


      -- print score keeping
      print("top score:", 10, 16, 0)
      print(game_world.top_score, 52, 16, 0)
      print("current score:", 10, 22, 0)
      print(player.score, 68, 22, 0)

      print("wave", 10, 118, 0)
      print(game_world.waves, 30, 118, 0)

   end

}