module MyModules
  module Util
    
    def dms_to_degrees(d, m, s, direction)
      result = d + m/60 + s/3600
      if (direction == "S" || direction == "W")
        result = result*-1;
      end
    end
    
  end
end