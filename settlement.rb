require "set"

class Settlement
  @settlements = []
  @exploited = Set.new
  
  def self.create tile
    @settlements << tile
    n = tile[:n]

    @exploited << (n - 1)
    @exploited << (n + 1)
    @exploited << (n - 19)
    @exploited << (n + 19)
    @exploited << (n - 20)
    @exploited << (n + 20)
    @exploited << (n - 21)
    @exploited << (n + 21)

  end
  
  def self.exploited_tiles
    @exploited
  end
  
  def self.year_harvest_calculations map
    total_matrix = Matrix.row_vector([0,0,0])
    @exploited.each do |n|
      total_matrix += map.tile(n)[:typ].res_matrix if (n > 0 and n < 400)
    end
    
    total_matrix
  end
  
  def self.year_feast_calculations map
    total_matrix = Matrix.row_vector([0,0,0])
    feast = Matrix.row_vector([-1,0,0])
    @exploited.each do |n|
      total_matrix += feast
    end
    
    total_matrix
  end

  
  def self.check_for_adjacent tile
    @exploited.each  do |n|
      t = tile[:n]
      return true if n == t  
    end
    
    false
  end
  
  def self.exploit_damage map
    n = rand(@exploited.size)
info "tile = #{@exploited.to_a[n]}"    
    hash = map.tile(@exploited.to_a[n])[:typ].select_minor_disaster
    hash[:n] = @exploited.to_a[n]
    
    hash
  end
  
  def self.first_settlement
    @settlements.first
  end
end
