class Season
  
  attr_writer :next_season
  attr_reader :name, :im
  
  def initialize name, im
    @name = name
    @im = im
  end
  
  def next
    @next_season
  end
end
