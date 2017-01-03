# Represents a rectangle in an SVG drawing
class Plottr::Rectangle < Plottr::Object
  tag_type "rect"

  attr_accessor :x, :y, :width, :height, :fill, :stroke
  options :x, :y, :width, :height, :fill, :stroke

  def origin= arr
    self.x = arr[0]
    self.y = arr[1]
  end

  def size= arr
    if arr.is_a? Numeric
      self.width = arr
      self.height = arr
    else
      self.width = arr[0]
      self.height = arr[1]
    end
  end
end