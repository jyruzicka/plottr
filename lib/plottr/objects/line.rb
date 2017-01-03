# Represents a line in an SVG drawing
class Plottr::Line < Plottr::Object
  # Has a start and end, defined as x and y
  attr_accessor :start_x, :start_y
  attr_accessor :end_x, :end_y

  # Set the stroke of the line
  attr_accessor :stroke

  # Set the opacity of the line
  attr_accessor :alpha

  # Other properties
  attr_accessor :properties

  def initialize(from:[0,0], to:[0,0], stroke: "black", alpha: 1.0)
    @start_x = from.first
    @start_y = from.last

    @end_x = to.first
    @end_y = to.last

    @stroke = stroke
    @alpha = alpha
  end

  def to_svg
    tag "line", x1: start_x, y1: start_y, x2: end_x, y2: end_y, stroke: stroke, opacity: alpha
  end
end