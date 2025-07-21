rotate = function(vect3, rot)

   sinA = sin(rot[3])
   sinB = sin(rot[2])
   sinY = sin(rot[1])

   cosA = cos(rot[3])
   cosB = cos(rot[2])
   cosY = cos(rot[1])

   x = (cosB * cosY * vect3[1]) + (((sinA * sinB * cosY) - (cosA * sinY)) * vect3[2]) + (((cosA * sinB * cosY) + (sinA * sinY)) * vect3[3])
   y = (cosB * sinY * vect3[1]) + (((sinA * sinB * sinY) + (cosA * cosY)) * vect3[2]) + (((cosA * sinB * sinY) - (sinA * cosY)) * vect3[3])
   z = (-sinB * vect3[1]) + (sinA * cosB * vect3[2]) + (cosA * cosB * vect3[3])

   return x, y, z

end

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