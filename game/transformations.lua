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