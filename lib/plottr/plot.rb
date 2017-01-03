# The Plot is a group of data, geoms, and preferences.
# It is rendered to SVG or PNG via a Renderer.
#
# The concern of the plot is:
# * Gathering everything together.
# * Providing global variables
# * Getting everything to render to itself
# * Keeping a register of maps and converters

class Plottr::Plot
  # The plot can also implement the before_render, render, and after_render options (for now!)
  include Plottr::Renderable
  
  # Allows `save_as` and `to_format`, as long as `to_svg` is implemented
  include Plottr::SVGable 

  # Allow xml tag creation
  include Plottr::Taggable

  # Stores data in the form of a `table` containing `column`s and `row`s.
  attr_accessor :data

  # Stores visualisation objects
  attr_accessor :visuals

  # This hash maps properties to aesthetics
  attr_accessor :map

  # This hash stores plot-wide converters, index by aesthetic
  attr_accessor :converters

  # Stores axes for this plot.
  attr_accessor :axes

  # Does this plot have a title?
  attr_accessor :title

  #---------------------------------------
  # Appearance accessors
  attr_accessor :margin
  attr_accessor :width, :height


  # Initialize
  def initialize(data=Plottr::Table.new(), map:{})
    
    @data = data
    @map = map
    
    @converters = {}
    @visuals = []
      
    # By default, x and y axes
    @axes = {
      x: Plottr::Axis.new(self, :x),
      y: Plottr::Axis.new(self, :y)
    }

    # Canvas duties
    @width = 800
    @height = 600
    @x_domain = (0..0)
    @y_domain = (0..0)
    @margin = {left: 0, right: 0, top: 0, bottom: 0}
  end

  # Add data or a visual to the plot
  def << object
    # What we do depends on what we pass it
    case object
    when Plottr::Row # Data row - append straight to plot's data
      @data << object
    when Hash # Hash of data - turn into a Row and add
      @data << Plottr::Row.new(object)
    when Plottr::Visual
      @visuals << object
      object.plot = self
    else
      raise TypeError, "Don't know how to process the #{object.class} passed to Plottr::Plot#<<."
    end
  end

  #---------------------------------------
  # The Map represents a mapping of properties to aesthetics.
  # The mapping is aesthetic -> property, in case you're wondering

  def map(aesthetic)
    @map[aesthetic]
  end

  def has_map?(aesthetic)
    @map.has_key?(aesthetic)
  end

  def create_map(aesthetic, property)
    @map[aesthetic] = property
  end

  #---------------------------------------
  # A converter converts a property value to an appropriate aesthetic values.
  # In order to do this, the domain (of inputs) to each converter is populated
  # during the pre-render phase, and the range (of outputs) needs to be suitably
  # set as well.
  def converter(aesthetic)
    @converters[aesthetic]
  end

  def has_converter?(aesthetic)
    @converters.has_key?(aesthetic)
  end

  def create_converter(aesthetic)
    c = Plottr::Converter.new()
    @converters[aesthetic] = c
    return c
  end

  # Ensures that:
  # (a) the plot has a Converter instantiated for this aesthetic
  # (b) this Converter covers the given coordinate in its domain
  def cover_coordinate(aesthetic, value)
    c = has_converter?(aesthetic) ? converter(aesthetic) : create_converter(aesthetic)
    c.expand_to_cover(value)
  end

  def cover_coordinates(aesthetic, values)
    c = has_converter?(aesthetic) ? converter(aesthetic) : create_converter(aesthetic)
    if c.continuous_domain?
      [values.min, values.max].each{ |v| c.expand_to_cover(v) }
    else
      values.each{ |v| c.expand_to_cover(v) }
    end
  end

  #---------------------------------------
  # Axis methods
  def x_axis
    @axes[:x]
  end

  def y_axis
    @axes[:y]
  end

  #---------------------------------------
  # Plotting methods
  #---------------------------------------

  # The @objects array stores all objects to be plotted.
  # It should be cleared before any plotting occurs
  def clear_objects
    @objects = []
  end

  # Add an object to the @objects array. Usually used in
  # visual renders
  def add_object o
    @objects << o
  end

  # These convenience methods allow us to add simple shapes
  def add_line(*args); add_object(Plottr::Line.new(*args)); end
  def add_circle(*args); add_object(Plottr::Circle.new(*args)); end
  def add_text(*args); add_object(Plottr::Text.new(*args)); end

  #---------------------------------------
  # SVGable methods
  #---------------------------------------

  def to_svg
    # Clear from previous to_svg calls
    clear_objects

    # Pre-render
    axes.values.each{ |axis| axis.before_render }
    visuals.each{ |viz| viz.before_render }

    set_domains_for_converters
    set_ranges_for_converters

    # Render
    if @title
      add_text(
        x: self.width/2,
        y: 30,
        anchor: :middle,
        size: 24,
        text: title
      )
    end

    axes.values.each{ |axis| axis.render }
    visuals.each{ |viz| viz.render }

    visuals.each{ |viz| viz.after_render }

    xml_tag(version: "1.0", encoding: "UTF-8", standalone: "no") + "\n" +
    tag("svg", width: self.width, height: self.height, xmlns: "http://www.w3.org/2000/svg") do
      @objects.map(&:to_svg).join("\n")
    end
  end

  def set_domains_for_converters
    converters.values.each{ |c| c.round_domain }
  end

  #---------------------------------------
  # Ranges for aesthetics!
  @ranges = {}
  class << self
    def set_range_for_aesthetic(aes, hsh=nil, &blck)
      raise ArgumentError, "Must supply a hash or block." if hsh.nil? && blck.nil?
      @ranges[aes] = hsh || blck
    end

    def range_for_aesthetic(aes)
      @ranges[aes]
    end
  end

  def set_ranges_for_converters
    @converters.each do |aes, converter|
      range = self.class.range_for_aesthetic(aes)
      if range.is_a?(Hash)
        converter.discrete_range = range[:discrete]
        converter.continuous_range = range[:continuous]
      elsif range.is_a?(Proc)
        range[converter, self]
      end
    end
  end

  # Which property is most associated with a given aesthetic?
  def property_for_aesthetic(aes)
    all_properties = visuals.map{ |viz| viz.map(aes) }
    properties = all_properties.uniq

    property_counts = properties.each_with_object({}){ |p,h| h[p] = all_properties.count(p) }
    max_property_count = property_counts.values.max

    return properties.find{ |p| property_counts[p] == max_property_count }
  end
end

Plottr::Plot.set_range_for_aesthetic(
    :colour,
    discrete: %w(red blue green orange yellow)
#     continuous: Plottr::Colour::HSB.new(0,100,80)..Plottr::Colour::HSB.new(0,100,0)
)

Plottr::Plot.set_range_for_aesthetic(:x) do |converter, plot|
  converter.continuous_range = plot.margin[:left]..(plot.width - plot.margin[:right])
end

Plottr::Plot.set_range_for_aesthetic(:y) do |converter, plot|
  converter.continuous_range = (plot.height - plot.margin[:bottom])..plot.margin[:top]
end