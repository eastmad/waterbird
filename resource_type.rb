require "matrix"

class ResourceType
  attr_reader :res_matrix, :graphic, :consume
  
  def initialize vector, graphic, consume
    @res_matrix = Matrix.row_vector(vector)
    @graphic = graphic
    @consume = Matrix.row_vector(consume)
  end
  
  def consume_vector
    @consume
  end
  
end

class None < ResourceType
  def initialize
    super [2, 1, 0], "graphics/f-ffff.jpg", [-1, -1, 0] 
  end
end
    
class Forest < ResourceType
  def initialize
    super [2, 1, 0], "graphics/f-ffff.jpg", [-1, -1, 0] 
  end
  
  def select_minor_disaster
    {:str => "Wild boar!", :id => :boar, :matrix => Matrix.row_vector([-1, -2, 0]), :cost => 1}
  end
end

class Mountain < ResourceType
  def initialize
    super [0, 1, 1], "graphics/m-mmmm.jpg", [-2, -2, 0]
  end
  
  def select_minor_disaster
    {:str => "Rockfall!", :id => :rockfall, :matrix => Matrix.row_vector([-1, -1, -1]), :cost => 3}
  end
end

class Plain < ResourceType
  def initialize
    super [1, 0, 0], "graphics/p-pppp.jpg", [-1, 0, 0]
  end
  
  def select_minor_disaster
    {:str => "Fire!", :id => :fire, :matrix => Matrix.row_vector([-2, -1, 0]), :cost => 2}
  end
end

class Water < ResourceType
  
  attr_reader :spring
  
  def initialize
    super [1, 0, 0], "graphics/w-wwww.jpg", [-1, -2, 0]
    
    @spring = 3 + rand(4)
  end
  
  def flow_in watr
    @spring += watr
  end
  
  def flow_out
    out_flow = 1 + rand(2)
    
    if @spring - out_flow > 0
      @spring -= out_flow
    else
      @spring = 0
      @out_flow = 0
    end
        
    out_flow
  end
  
  def select_minor_disaster
    {:str => "Flood!", :id => :flood, :matrix => Matrix.row_vector([-1, -1, 0]), :cost => 1}
  end
end
