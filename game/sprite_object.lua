sprite_object = {

   -- initialise needed variables that may be left un-initiated by instances of sub-classes

   -- eg with sprites that do not flip
   flip_x = false,
   flip_y = false,

   -- default to particular sprite pattern, for debugging
   sprite_x = 8,
   sprite_y = 0,
   sprite_w = 16,
   sprite_h = 8,

   draw = function(self)

      if self.pre_draw then self:pre_draw() end

      if game_world.mode == "boss" then
         x, y, z = boss_mode_rotate({self.x, self.y, self.z}, game_world.rotation)
      else
         x, y, z = self.x, self.y, self.z
      end

      --[[
      -- calculate appriopriate world position of the top right and bottom left of the sprite relative to camera
      transf_x1, transf_y1, transf_z1 = rotate({self.x - (self.width / 2),
                                                self.y - (self.height / 2),
                                                self.z}, camera:orientation())

      transf_x2, transf_y2, transf_z2 = rotate({self.x + (self.width / 2),
                                                self.y + (self.height / 2),
                                                self.z}, camera:orientation())

                                                ]]--

      -- project top-left and bottom-right corner positions using projection formula
      screen_x1, screen_y1 = project_vert({x - (self.width / 2),
                                           y + (self.height / 2),
                                           z})
      screen_x2, screen_y2 = project_vert({x + (self.width / 2),
                                           y - (self.height / 2),
                                           z})

      -- draw scaled sprite
      if z >= 1 then
         sspr(self.sprite_x, self.sprite_y,
            self.sprite_w, self.sprite_h,
            screen_x1, screen_y1,
            screen_x2 - screen_x1, screen_y2 - screen_y1,
            self.flip_x, self.flip_y)
      end

      if self.post_draw then self:post_draw() end

   end

}