# This module allows a class to be rendered as SVG, and therefore
# saved as an SVG or other format.
# Chiefly used for the `Plot` class.
module Plottr::SVGable
  # Save to file. Format to be determined from extension
  def save_as(filename)
    extension = File.extname(filename).gsub(/^\./,'')
    File.open(filename,"w"){ |io| io.puts self.to_format(extension) }
  end

  # Render as a certain file format
  def to_format(format)
    case format
    when "svg"
      self.to_svg
    else
      raise RuntimeError, "Cannot convert to format #{format}."
    end
  end

  # Render as svg. Used as a base for all other rendering operations
  def to_svg
    # Implemented by class
    raise RuntimeError, "Abstract method `to_svg` called for module SVGable"
  end
end