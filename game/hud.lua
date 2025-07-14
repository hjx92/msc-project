hud = {

   update = function(self)
   end,

   draw = function(self)
      
      -- draw player health
      print("health", 10, 10, 0)
      rectfill(36, 10, 46 + (player.life * 10), 14, 8)

      -- draw weapon info

      -- lock counter
      print("lock-ons:", 10, 113, 0)
      print(#player.targets, 47, 113, 0)
      print("/", 52, 113, 0)
      print(player.target_limit, 56, 113, 0)
      rectfill(62, 113, 62 + (player.lock_cooldown), 117, 9)

   end

}