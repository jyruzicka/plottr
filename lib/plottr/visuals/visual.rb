# This class represents an abstract "visual element" of the plot.
# Examples would include a scatter plot, a bar graph, a line graph,
# a heat map, etc. Maps to ggplot's "geom".
class Plottr::Visual
  include Plottr::Renderable

  # Each visual belongs to a plot.
  attr_accessor :plot

  # Each visual has a certain number of aesthetics. This hash maps properties to aesthetics
  # Form: aes -> property
  attr_accessor :map

  ## Class methods
  class << self
    attr_reader :required_aesthetics, :optional_aesthetics

    def requires_aesthetic *args
      @required_aesthetics = (@required_aesthetics || []) + args
    end

    def optional_aesthetic *args
      @optional_aesthetics = (@optional_aesthetics || []) + args
    end

    def requires_aesthetic?(m)
      @required_aesthetics.include?(m)
    end

    def optional_aesthetic?(m)
      @optional_aesthetics.include?(m)
    end
  end

  ## End class methods

  def initialize(map:{})
    @map = map
  end

  #---------------------------------------
  # Converter methods
  def converter(aes)
    plot && plot.converter(aes)
  end
  
  def has_converter?(aes)
    plot && plot.has_converter?(aes)
  end

  #---------------------------------------
  # Map methods. Note that maps can be local
  # (i.e. on the visual) or global (i.e. on the plot)
  def map(aes)
    local_map(aes) || (plot && plot.map(aes))
  end

  def has_map?(aes)
    has_local_map?(aes) || (plot && plot.has_map?(aes))
  end

  def local_map(aes)
    @map[aes]
  end

  def has_local_map?(aes)
    @map.has_key?(aes)
  end
    
  #---------------------------------------
  # Other stuff

  # Is this visual valid? A valid visual:
  # * has a map for each required_aesthetic
  # * may have a map for any optional_aesthetic
  # * has no local maps for other variables
  def valid?
    return false unless self.class.required_aesthetics.all?{ |m| has_map?(m) }
    return false unless @map.keys.all?{ |k| self.class.requires_aesthetic?(k) || self.class.optional_aesthetic?(k) }
    return true
  end

  # This method uses mapping and conversion to return the proper
  # value for a given row and aesthetic.
  def aes(row, aesthetic)
    property = self.map(aesthetic)
    return nil if property.nil?

    input = row[property]
    converter = plot.converter(aesthetic)
    return converter[input]
  end

  # These methods allow us to get to our plot variables
  def data
    plot && plot.data
  end

  #---------------------------------------
  # Default before_render method
  def before_render
    self.class.required_aesthetics.each do |s|
      inputs = data.rows.map{ |r| r[self.map(s)] }
      plot.cover_coordinates(s, inputs)
    end

    self.class.optional_aesthetics.select{ |s| self.has_map?(s) }.each do |s|
      inputs = data.rows.map{ |r| r[self.map(s)] }
      plot.cover_coordinates(s, inputs)
    end
  end
end