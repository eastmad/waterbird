class Map
  
  attr_reader :width, :height
  
  def initialize width, height
    @map = Array.new(width * height)
    @width = width
    @height = height
    @directions = [:left, :right, :above, :below]
    @resource_types = [Plain, Mountain, Forest, Plain, Mountain, Forest, Plain, Mountain, Forest, Plain, Water]
    @null_tile = {:n => -1, :x => -1, :y => -1, :typ => Water.new}
  end
  
  def create origx,origy,size
    n = 0 
    (0..@width - 1).each do |i|
      (0..@height - 1).each do |j|
        r = rand(@resource_types.size)
        klass = @resource_types[r]
        set_map_tile(n,(i*size)+origx,(j*size)+origy,klass.new)
        n += 1
      end
    end
    
    @map.each do |t|
      n = t[:n]
      t.merge!({:left => tile(n - @width),
                    :right => tile(n + @width),
                    :above => tile(n - 1), 
                    :below => tile(n + 1)})
    end
    
    (1..3).each do
    @map.each do |t|
      if t[:typ].class == Water and t[:typ].spring
        water_flow t
      end
    end
    end
  end
  
  
  def water_flow water_tile
    dir = @directions[rand(@directions.size)]
    info "directions =#{dir.to_sym}, #{water_tile[dir][:n]}"
    new_tile = water_tile[dir]    
    
    if (new_tile[:typ].class == Water)
      info "make flow"
      new_tile[:typ].flow_in(water_tile[:typ].flow_out)
    elsif new_tile[:typ].class == Plain
      info "make water"
      new_tile[:typ] = Water.new
      new_tile[:typ].flow_in(water_tile[:typ].flow_out)
    end
    
  end
  
  def set_map_tile(n,x,y,typ)
    #info "set map #{n}, (#{x},#{y}) = #{typ}"
    @map[n] = {:n => n, :x => x, :y => y, :typ => typ}              
  end
  
  def tile(n)
    return @null_tile  if n < 0 or n >= (@width * @height) 
    
    @map[n]
  end
  
  def mouse_to_tile(x, y)
    @map.each do |t|
      return t if x >= t[:x] and x < (t[:x] + 33) and y >= t[:y] and y < (t[:y] + 32)
    end
    
    nil
  end
  
  def next_journey_tile from_tile, to_tile_n
    n = from_tile[:n]
    to_tile = tile(to_tile_n)
    
    if from_tile[:x] < to_tile[:x]
      n = n + 20
    elsif from_tile[:x] > to_tile[:x]
      n = n - 20
    end
    
    if from_tile[:y] < to_tile[:y]
      n = n + 1
    elsif from_tile[:y] > to_tile[:y]
      n = n - 1
    end
 
    tile(n)
  end
  
  def consume tile, resource
    val = resource.vector + tile[:typ].consume
    info "resource.vector = #{resource.vector}"
    info "tile[:typ].consume = #{tile[:typ].consume}"
    info "val = #{val}"
    
    raise "Explorers need food" if val.row(0)[0] < 0
    raise "Explorers need materials" if val.row(0)[1] < 0
    raise "Explorers need gold" if val.row(0)[2] < 0
    
    resource.add tile[:typ].consume
  end
  
  def check_water_surrounding t, adj_set
    adj_set.each do |orient, bool|
      return false unless check_adjacent_type(t, orient, Water) == bool
    end
    
    true
  end
  
  def check_adjacent_type t, orient, klass
    return true if (t[orient][:typ].class == klass)
    false
  end
end
