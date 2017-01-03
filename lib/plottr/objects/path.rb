# Represents a path in an SVG drawing
class Plottr::Path < Plottr::Object
  tag_type "path"

  attr_accessor :d, :fill, :stroke
  options :d, :fill, :stroke

  def initialize(hsh={})
    self.d = ""
    super(hsh)
  end

  def origin= p
    self.d = "M#{p[0]},#{p[1]}"
  end

  def line p
    self.d += " L#{p[0]},#{p[1]}"
  end

  def close
    self.d += " z"
  end
end