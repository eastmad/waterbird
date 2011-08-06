require_relative "resource_type"
require_relative "map"
require_relative "settlement"
require_relative "season"
require_relative "resources"


Shoes.app(:width => 1024, :height => 800, :title => "Waterbird 1.0") {
  background rgb(20, 42, 42)
  stroke white
  
  @map = Map.new(20,20)
  @map.create(0,50,32)
  
  flow(:width =>1020, :height => 800){
   
    @map_slot = stack(:width => 650) {
      n = 20*20 - 1
      (0..n).each do |i|
        tile = @map.tile(i)
        gr = tile[:typ].graphic
        #info "gr = #{gr}"
        if tile[:typ].class == Water
          if  @map.check_water_surrounding(tile,{:left => false, :above => true, :below => false, :right => false})
            im = image "graphics/w-wlll.jpg", :width => 32, :height => 32, :left => tile[:x], :top => tile[:y]
          elsif  @map.check_water_surrounding(tile,{:left => false, :above => false, :below => false, :right => true})
            im = image "graphics/w-lwll.jpg", :width => 32, :height => 32, :left => tile[:x], :top => tile[:y]
          elsif @map.check_water_surrounding(tile,{:left => false, :above => false, :below => true, :right => false})
            im = image "graphics/w-llwl.jpg", :width => 32, :height => 32, :left => tile[:x], :top => tile[:y]
          elsif @map.check_water_surrounding(tile,{:left => true, :above => false, :below => false, :right => false})
            im = image "graphics/w-lllw.jpg", :width => 32, :height => 32, :left => tile[:x], :top => tile[:y]
          elsif @map.check_water_surrounding(tile,{:left => false, :above => true, :below => true, :right => false})
            im = image "graphics/w-wlwl.jpg", :width => 32, :height => 32, :left => tile[:x], :top => tile[:y]
          elsif @map.check_water_surrounding(tile,{:left => true, :above => false, :below => false, :right => true})
            im = image "graphics/w-lwlw.jpg", :width => 32, :height => 32, :left => tile[:x], :top => tile[:y]
          elsif @map.check_water_surrounding(tile,{:left => false, :above => false, :below => true, :right => true})
            im = image "graphics/w-lwwl.jpg", :width => 32, :height => 32, :left => tile[:x], :top => tile[:y]
          elsif @map.check_water_surrounding(tile,{:left => true, :above => false, :below => true, :right => false})
            im = image "graphics/w-llww.jpg", :width => 32, :height => 32, :left => tile[:x], :top => tile[:y]
          elsif @map.check_water_surrounding(tile,{:left => true, :above => true, :below => false, :right => false})
            im = image "graphics/w-wllw.jpg", :width => 32, :height => 32, :left => tile[:x], :top => tile[:y]        
          elsif @map.check_water_surrounding(tile,{:left => false, :above => true, :below => false, :right => true})
            im = image "graphics/w-wwll.jpg", :width => 32, :height => 32, :left => tile[:x], :top => tile[:y]        
          elsif @map.check_water_surrounding(tile,{:left => true, :above => false, :below => true, :right => true})
            im = image "graphics/w-lwww.jpg", :width => 32, :height => 32, :left => tile[:x], :top => tile[:y]        
          elsif @map.check_water_surrounding(tile,{:left => true, :above => true, :below => true, :right => false})
            im = image "graphics/w-wlww.jpg", :width => 32, :height => 32, :left => tile[:x], :top => tile[:y]        
          elsif @map.check_water_surrounding(tile,{:left => true, :above => true, :below => false, :right => true})
            im = image "graphics/w-wwlw.jpg", :width => 32, :height => 32, :left => tile[:x], :top => tile[:y]        
          elsif @map.check_water_surrounding(tile,{:left => false, :above => true, :below => true, :right => true})
            im = image "graphics/w-wwwl.jpg", :width => 32, :height => 32, :left => tile[:x], :top => tile[:y]        
          elsif @map.check_water_surrounding(tile,{:left => false, :above => false, :below => false, :right => false})
            im = image "graphics/w-llll.jpg", :width => 32, :height => 32, :left => tile[:x], :top => tile[:y]
          elsif @map.check_water_surrounding(tile,{:left => true, :above => true, :below => true, :right => true})
            im = image "graphics/w-wwww.jpg", :width => 32, :height => 32, :left => tile[:x], :top => tile[:y]          
          end      
        else
          im = image gr, :width => 32, :height => 32, :left => tile[:x], :top => tile[:y]
        end
        tile[:im] = im
      end      
    }
      
      
      
    tile = @map.tile(210)
    create_village(tile)
  
    @flag = image "graphics/flag.gif", :width => 24, :height => 24
    @flag.hide
    
    @marker_land = image "graphics/shield.gif", :width => 24, :height => 24
    @marker_sea = image "graphics/boat.gif", :width => 24, :height => 24
    @marker_land.hide
    @marker_sea.hide
    
    @marker_moving = true
  
    @disaster = {}
    
    @disaster[:flood] = image "graphics/flood.gif", :width => 24, :height => 24
    @disaster[:flood].hide
    
    @disaster[:fire] = image "graphics/fire.gif", :width => 24, :height => 24
    @disaster[:fire].hide
    
    @disaster[:boar] = image "graphics/boar.gif", :width => 24, :height => 24
    @disaster[:boar].hide
    
    @disaster[:rockfall] = image "graphics/rocks.gif", :width => 24, :height => 24
    @disaster[:rockfall].hide
    
    @current_disaster = @disaster[:rockfall]
    
      
    info "done"
    @season = 3
    @time = 4
    @resources = Resources.new
    @flag_tile = nil
    @marker_tile = nil
    
    stack(:width => 200, :top => 50) {
      flow {
        @aut = image "graphics/autumn.jpg", :width => 64, :height => 64
        @win = image "graphics/winter.jpg", :width => 64, :height => 64
        @spr = image "graphics/spring.jpg", :width => 64, :height => 64
        @sum = image "graphics/summer.jpg", :width => 64, :height => 64
        @win.hide
        @spr.hide
        @sum.hide
      }
      flow {
        tagline strong("Food "), :stroke => red
        @f = tagline @resources.food, :stroke => red
      }
      flow {
        tagline strong("Material "), :stroke => brown
        @m = tagline @resources.material, :stroke => brown
      }
      flow {
        tagline strong("Gold "), :stroke => yellow
        @g = tagline @resources.gold, :stroke => yellow
      }
      @message = tagline "Hail!", :stroke => white 
      @warning = caption "", :stroke => red
      caption "- Click a square to send settlers", :stroke => gray
      caption "- Settlers need food and material", :stroke => gray
      caption "- Plains are easy to cross", :stroke => gray
      caption "- Build near forests and mountains", :stroke => gray
      caption "- Gold helps buy repairs", :stroke => gray
      caption "- When you are rich, build a castle!", :stroke => gray
    }
  }
  
  @season = Season.new(:autumn, @aut)
  @season.next_season = Season.new(:winter, @win)
  @season.next.next_season = Season.new(:spring, @spr)
  @season.next.next.next_season = Season.new(:summer, @sum)
  @season.next.next.next.next_season = @season
  
  animate do
    button, left, top = self.mouse
    tile = @map.mouse_to_tile(left,top)
    #@p.replace "mouse: #{button}, #{left}, #{top}, tile = #{tile}"
    
    if button == 1
      target(tile)
    end
  end
  
  every (1) do
    if @time == 0
      @time = 4
      @season.im.hide()
      @season = @season.next
      @season.im.show()
      
      if (@season.name == :winter)
        @message.replace "Winter feast!"
        matrx = Settlement.year_feast_calculations @map
        @resources.add matrx
        update_score
      end
      
      if (@season.name == :summer)
        @message.replace "Harvest!"
        matrx = Settlement.year_harvest_calculations @map
        @resources.add matrx
        update_score
      end
    end
    
    if (@time == 2)
      dam_hash = Settlement.exploit_damage @map
      @message.replace dam_hash[:str]      
      tile = @map.tile(dam_hash[:n])

      @current_disaster = @disaster[dam_hash[:id]]
      @current_disaster.move tile[:x], tile[:y] 
      @current_disaster.show
      
      @resources.add dam_hash[:matrix]
      if @resources.gold >= dam_hash[:cost]
        @resources.gold -= dam_hash[:cost]
      else
        @resources.add dam_hash[:matrix]
      end
      update_score
      
    end
    
    if (@time == 3)
      @current_disaster.hide
      @current_disaster = nil
    end
    
    unless (@flag_tile.nil?)
      info "flag tile set"
      @start = @marker_tile || Settlement.first_settlement
      
      @marker_tile = @map.next_journey_tile @start, @flag_tile if @marker_moving
      
      if @marker_tile[:n] == @flag_tile
        @flag_tile = nil        
        @flag.hide
        @marker_land.hide
        @marker_sea.hide
        
        if @resources.gold > 50 and @resources.material > 200
          create_castle(@marker_tile)
          @resources.gold -= 50
          @resources.material -= 200
          @message.replace "CASTLE!"
        else
          create_village(@marker_tile)
          @message.replace "New settlement!"
        end
        
        @marker_tile = nil
      else
        marker(@marker_tile)
      end
    end  
    
    @time -= 1
  end
  
  def target tile
    begin
      raise "This is too near an existing settlement!" if Settlement.check_for_adjacent(tile)
      raise "Cannot settle on water" if tile[:typ].class == Water
      
      @flag.move tile[:x], tile[:y]
      @flag.show
      @flag_tile = tile[:n]
    
      info "target set = #{@flag_tile}"
      @message.replace "Ho!"
      
    rescue => ex
      @warning.replace ex
    end
  end
  
  def marker tile
    
    begin
      
      if tile[:typ].class == Water
        @marker_sea.move tile[:x], tile[:y]
        @marker_sea.show
        @marker_land.hide
      else
        @marker_land.move tile[:x], tile[:y]
        @marker_land.show
        @marker_sea.hide
      end
      
      @map.consume(tile, @resources)
      update_score  

      
      @marker_tile = tile
      @marker_moving = true
    rescue => ex
      @warning.replace ex
      @marker_moving = false
    end  
    
    info "target set = #{@flag_tile}"
  end
  
  def clear_flag tile
    @flag.hide
    @flag_tile = nil
  end
  
  def update_score
    @f.replace "#{@resources.food}"
    @m.replace "#{@resources.material}"
    @g.replace "#{@resources.gold}"
  end
  
}

def create_village tile
  create_settlement tile, "graphics/settlement.gif"
end

def create_castle tile
  create_settlement tile, "graphics/castle.gif"
end

def create_settlement tile, grp
  info "create settlement"
  im = image grp, :width => 48, :height => 48, :left => tile[:x] - 8, :top => tile[:y] - 8
  @map_slot.contents() << im
  Settlement.create tile
  Settlement.exploited_tiles.each do |n|
    ex_tile = @map.tile(n)
    im = image "graphics/pickaxe.gif", :width => 16, :height => 16, :left => ex_tile[:x], :top => ex_tile[:y]
    @map_slot.contents() << im
  end
end


