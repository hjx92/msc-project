scenery_object = {

   scroll_speed = 0.2,

   new_tree = function(self)

      x_rand = 5 - rnd(10)
      h_rand = 0.6 + rnd(0.4)
      w_rand = 0.3 + rnd(0.2)

      xflip_rand = (rnd(1) > 0.5)

      tree = {

         type = "tree",

         x = x_rand + camera.x,
         y = (h_rand / 2) - 2,
         height = h_rand,
         width = w_rand,

         flip_x = xflip_rand,
         flip_y = false

      }

      assign_tree(tree)
      setmetatable(tree, {__index = self})
      return tree

   end,

   new_rock = function(self)

      x_rand = 5 - rnd(10)
      h_rand = 0.2 + rnd(0.2)
      w_rand = 0.2 + rnd(0.2)

      xflip_rand = (rnd(1) > 0.5)

      rock = {

         type = "rock",

         x = x_rand + camera.x,
         y = (h_rand / 2) - 2,
         height = h_rand,
         width = w_rand,

         flip_x = xflip_rand,
         flip_y = false

      }

      assign_rock(rock)
      setmetatable(rock, {__index = self})
      return rock

   end,

   new_cloud = function(self)

      x_rand = 5 - rnd(10)
      y_rand = rnd(1)
      h_rand = 0.6 + rnd(0.6)
      w_rand = 1.2 + rnd(1.2)

      xflip_rand = (rnd(1) > 0.5)
      yflip_rand = (rnd(1) > 0.5)

      cloud = {

         type = "cloud",

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

      assign_cloud(cloud)
      setmetatable(cloud, {__index = self})
      return cloud

   end,

   load = function(self, item)

      if item.type == "tree" then assign_tree(item) end
      if item.type == "rock" then assign_rock(item) end
      if item.type == "cloud" then assign_cloud(item) end

      setmetatable(item, {__index = self})
      return item

   end,

   update = function(self)
      
      self.z -= self.scroll_speed

   end,
}

assign_tree = function(item)

   item.sprite_x = 0
   item.sprite_y = 0
   item.sprite_w = 8
   item.sprite_h = 16

end

assign_rock = function(item)

   item.sprite_x = 56
   item.sprite_y = 8
   item.sprite_w = 8
   item.sprite_h = 8

end

assign_cloud = function(item)

   item.sprite_x = 8
   item.sprite_y = 8
   item.sprite_w = 16
   item.sprite_h = 8

end