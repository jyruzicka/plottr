# This represents an x-y scatterplot. Note that we currently only support one x-
# and one y-axis - no x2 axis for us yet!
class Plottr::Scatter < Plottr::Visual
  # Must have exactly one x-type map, and one y-type map
  requires_aesthetic :x, :y
  optional_aesthetic :colour, :shape

  # The colour of each point on the scatter. Can be overriden by map
  attr_accessor :fill

  # Colour of border. Defaults to black.
  attr_accessor :stroke

  # Shape of each point
  attr_accessor :shape
  ALLOWED_SHAPES = %i(solid_circle solid_box solid_triangle hollow_circle hollow_box hollow_triangle)
  SHAPE_METHODS =  %i(circle box triangle circle box triangle)
  FILL_TYPES =     %i(solid solid solid hollow hollow hollow)

  # Initialize
  def initialize(map:{}, fill:"black", shape: :solid_circle, stroke: "black")
    super(map)
    self.fill = fill
    self.shape = shape
    self.stroke = stroke
  end

  def shape= s
    raise ArgumentError, "Shape must be one of Scatter::ALLOWED_SHAPES" unless ALLOWED_SHAPES.include?(s)
    @shape = s
  end

  # Render to a renderer.
  # For a scatter graph:
  # - for each point, add a small circle to the plot
  def render
    shape_size = plot.width / 200
    rows = data.rows

    points = rows.map do |r|
      x = aes(r,:x)
      y = aes(r,:y)
      shape = aes(r,:shape) || self.shape
      
      shape_idx = ALLOWED_SHAPES.index(shape)
      shape_method = SHAPE_METHODS[shape_idx]
      fill_type = FILL_TYPES[shape_idx]

      my_fill = aes(r,:fill) || self.fill
      my_stroke = self.stroke

      shape = self.send(shape_method,x,y,shape_size)
      if fill_type == :solid
        shape.fill = my_fill
        shape.stroke = my_stroke
      else
        shape.fill = "none"
        shape.stroke = my_fill
      end
      shape
    end

    points.each{ |pt| plot.add_object(pt) }
  end

  private
  # Shape methods. Sizes are modified in order to give the same area per symbol.
  # Circle scale is 1 (A=πs²)
  # Rectangle scale is √(π/2) or 1.25
  # Triangle scale is 1.55
  def circle(x,y,size)
    Plottr::Circle.new(centre: [x,y], radius: size)
  end

  def box(x,y,size)
    size *= 0.87
    Plottr::Rectangle.new(origin: [x,y], size: size*2)
  end

  def triangle(x,y,size)
    size *= 1.55
    adjacent = size * Math::sqrt(3) / 2
    half_size = size / 2
    points = []
    points << [x, y-size]
    points << [x + adjacent, y + half_size]
    points << [x - adjacent, y + half_size]
    path = Plottr::Path.new(origin: points.shift)
    points.each{ |p| path.line(p)}
    path.close
    path
  end
end

Plottr::Plot.set_range_for_aesthetic(:shape, discrete: Plottr::Scatter::ALLOWED_SHAPES)