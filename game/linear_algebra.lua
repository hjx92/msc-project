cross_product = function(v1, v2)

   return {v1[2] * v2[3] - v1[3] * v2[2],
           v1[3] * v2[1] - v1[1] * v2[3],
           v1[1] * v2[2] - v1[2] * v2[1]}

end

dot_product = function(v1, v2)

   return (v1[1] * v2[1] + v1[2] * v2[2] + v1[3] * v2[3])

end

subtract = function(v1, v2)

   return {v1[1] - v2[1], v1[2] - v2[2], v1[3] - v2[3]}

end

addition = function(v1, v2)

   return {v1[1] + v2[1], v1[2] + v2[2], v1[3] + v2[3]}

end

scale = function(v1, scale)

   return {v1[1] * scale, v1[2] * scale, v1[3] * scale}

end