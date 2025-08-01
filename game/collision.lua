collides = function(body1, body2)

   return (abs(body1.x - body2.x) < (body1.width / 2) + (body2.width / 2) and
           abs(body1.y - body2.y) < (body1.height / 2) + (body2.height / 2) and
           abs(body1.z - body2.z) < (body1.depth / 2) + (body2.depth / 2))

end