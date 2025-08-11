explosion = {

   sprite_x = 24,
   sprite_y = 0,
   sprite_w = 16,
   sprite_h = 16,

   new = function(self, x, y, z)

      new_explosion = {}
      setmetatable(new_explosion, {__index = self})
      new_explosion.parts = self:populate_particles(x, y, z)
      new_explosion.counter = 30
      new_explosion.x = x
      new_explosion.y = y
      new_explosion.z = z
      new_explosion.height = 0
      new_explosion.width = 0
      new_explosion.growth_rate = (0.01) + rnd(0.01)
      new_explosion.x_flip = false
      new_explosion.y_flip = false

      return new_explosion

   end,

   update = function(_ENV)

      counter -= 1

      for i = 1, #parts do
         parts[i][1] += parts[i][4]
         parts[i][2] += parts[i][5]
      end

      height += growth_rate
      width += growth_rate

      if counter < 20 then x_flip = true end
      if counter < 10 then y_flip = true end

   end,

   post_draw = function(self)

      for i = 1, #self.parts do
         x, y = project_vert({self.parts[i][1], self.parts[i][2], self.parts[i][3]})
         circfill(x, y, 0, self.parts[i][6])
      end

   end,

   populate_particles = function(self, x, y, z)

      parts = {}
      particle_count = flr(rnd(20)) + 10

      for i = 1, particle_count do
         selector = rnd(1)

         if selector < 0.5 then colour = 1
            else if selector > 0.8 then colour = 5
               else colour = 6
            end
         end

         particle_magnitude = rnd(0.1)

         add(parts, {x, y, z, rnd(particle_magnitude) - particle_magnitude / 2, rnd(particle_magnitude) - particle_magnitude / 2, colour})

      end

      return parts

   end

}