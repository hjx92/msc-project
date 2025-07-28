boss_mode_rotate = function(vect3, angle)

   angle *= -1

   -- unpack point, pulling it five points forward to rotate around 0, 0
   x = vect3[1]
   y = vect3[2]
   z = vect3[3] - 5

   radius = sqrt((x * x) + (z * z))

   original_angle = atan2(x, z)
   angle += original_angle

   x = radius * cos(angle)
   z = radius * sin(angle)

   -- translate back into proper world depth
   z += 5

   return x, y, z

end