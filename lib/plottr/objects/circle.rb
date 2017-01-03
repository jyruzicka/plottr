# Represents a circle in an SVG drawing
class Plottr::Circle < Plottr::Object
  tag_type "circle"

  attr_accessor :x, :y, :radius, :fill, :stroke
  options :fill, :stroke, {cx: :x}, {cy: :y}, {r: :radius}

  def centre= arr
    self.x = arr[0]
    self.y = arr[1]
  end

  # def to_svg
  #   tag "circle", cx: x, cy: y, r: radius
  # end
end