# Represents an SVG text element
class Plottr::Text < Plottr::Object
  tag_type "text"
  
  options :x, :y,
    {"text-anchor": :anchor},
    :dx, :dy,
    :transform,
    {"font-family": :font}, {"font-size": :size}

  inside_element{ self.text }

  # Currently, text has an x and y value, and a text which
  # is the text it displays.
  attr_accessor :x, :y, :text

  # Set font family and size
  attr_accessor :font, :size

  # `anchor` set the alignment of the text
  attr_accessor :anchor

  # Alter the x and y position of the text element
  attr_accessor :dx, :dy

  # Rotation value
  attr_accessor :rotate

  ANCHOR_VALUES = %i(start middle end inherit)

  def at= arr
    self.x = arr[0]
    self.y = arr[1]
  end

  # Gives us the SVG transform() property, based on object's rotate value
  def transform
    if rotate
      "rotate(#{rotate},#{x},#{y})"
    else
      nil
    end
  end

  def anchor=val
    raise ArgumentError, "Text#anchor must be set to a value anchor value." unless ANCHOR_VALUES.include?(val)
    @anchor = val
  end
end