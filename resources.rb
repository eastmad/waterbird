class Resources
  attr_accessor :food, :material, :gold
  
  def initialize
    @food = 3
    @material = 4
    @gold = 2
  end
  
  def vector
    Matrix.row_vector([@food, @material, @gold])
  end
  
  def reduce row_vector
    @food -= row_vector.row(0)[0]
    @material -= row_vector.row(0)[1]
    @gold -= row_vector.row(0)[2]
  end
  
  def add row_vector
    @food += row_vector.row(0)[0]
    @material += row_vector.row(0)[1]
    @gold += row_vector.row(0)[2]
    
    @food = 0 if @food < 0
    @material = 0 if @material < 0
    @gold = 0 if @gold < 0
  end
end
