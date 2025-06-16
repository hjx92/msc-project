particles = {

   new = function(self, x, y)

      new_particles = {}
      setmetatable(new_particles, {__index = self})
      new_particles.parts = self:populate_particles(x, y)
      new_particles.counter = 30

      return new_particles

   end,

   update = function(self)

      self.counter -= 1

      for i = 1, #self.parts do
         self.parts[i][1] += self.parts[i][3]
         self.parts[i][2] += self.parts[i][4]
      end

   end,

   draw = function(self)

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