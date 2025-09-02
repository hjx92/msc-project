project_vert = function(vect3)

   return 64 + (((vect3[1] - camera.x) / vect3[3]) * 128), 64 - (((vect3[2] - camera.y) / vect3[3]) * 128)

end