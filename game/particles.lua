particles = {

   new = function(self, x, y)

      new_particles = {}
      setmetatable(new_particles, {__index = self})
      new_particles.parts = self:populate_particles(x, y)
      new_particles.counter = 30
      new_particles.x = x
      new_particles.y = y
      new_particles.sprite_size = 0
      new_particles.growth_rate = (0.1) + rnd(0.3)
      new_particles.x_flip = false
      new_particles.y_flip = false

      return new_particles

   end,

   update = function(self)

      self.counter -= 1

      for i = 1, #self.parts do
         self.parts[i][1] += self.parts[i][3]
         self.parts[i][2] += self.parts[i][4]
      end
      new_particles.sprite_size += self.growth_rate
      if self.counter < 20 then self.x_flip = true end
      if self.counter < 10 then self.y_flip = true end

   end,

   draw = function(self)

      sspr(24, 0, 16, 16, self.x - (self.sprite_size) / 2, self.y - (self.sprite_size) / 2, self.sprite_size, self.sprite_size, self.x_flip, self.y_flip)

      for i = 1, #self.parts do
         circfill(self.parts[i][1], self.parts[i][2], 0, self.parts[i][5])
      end

   end,

   populate_particles = function(self, x, y)

      parts = {}
      particle_count = flr(rnd(20)) + 10

      for i = 1, particle_count do
         selector = rnd(1)

         if selector < 0.5 then colour = 1
            else if selector > 0.8 then colour = 5
               else colour = 6
            end
         end

         particle_magnitude = rnd(1)

         add(parts, {x, y, rnd(particle_magnitude) - particle_magnitude / 2, rnd(particle_magnitude) - particle_magnitude / 2, colour})

      end

      return parts

   end
}