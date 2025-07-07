scenery_object = {

   undulating = false,
   scroll_speed = 0.2,

   new_tree = function(self)

      x_rand = 5 - rnd(10)
      h_rand = 0.6 + rnd(0.4)
      w_rand = 0.3 + rnd(0.2)

      xflip_rand = (rnd(1) > 0.5)

      tree = {

         x = x_rand + camera.x,
         y = (h_rand / 2) - 2,
         height = h_rand,
         width = w_rand,

         sprite_x = 0,
         sprite_y = 0,
         sprite_w = 8,
         sprite_h = 16,

         flip_x = xflip_rand,
         flip_y = false

      }

      setmetatable(tree, {__index = self})
      return tree

   end,

   new_cloud = function(self)

      x_rand = 5 - rnd(10)
      y_rand = rnd(1)
      h_rand = 0.6 + rnd(0.6)
      w_rand = 1.2 + rnd(1.2)

      xflip_rand = (rnd(1) > 0.5)
      yflip_rand = (rnd(1) > 0.5)

      cloud = {

         x = x_rand + camera.x,
         y = 4 + y_rand,
         height = h_rand,
         width = w_rand,

         sprite_x = 8,
         sprite_y = 8,
         sprite_w = 16,
         sprite_h = 8,

         flip_x = xflip_rand,
         flip_y = yflip_rand

      }

      setmetatable(cloud, {__index = self})
      return cloud

   end,

   new_wave = function(self)

      wave = {
         undulating = true,
      }

      setmetatable(wave, {__index = self})
      return wave

   end,

   update = function(self)
      
      self.z -= self.scroll_speed
      if self.undulating then
         self:undulate()
      end

   end,

   undulate = function(self)
   end
}