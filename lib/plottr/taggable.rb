# The Taggable module allows you to make tags using the `tag` and `xml_tag` methods
module Plottr::Taggable
  # Simple method to create a tag
  def tag(name, opts={}, &blck)
    return_string = "<#{name}" + opts.map{ |k,v| %| #{k}="#{v}"| }.join("")
    if blck
      return_string + ">\n" + blck[].to_s + "\n</#{name}>"
    else
      return_string + " />"
    end
  end

  # Create an xml tag
  def xml_tag(opts={})
    "<?xml" + opts.map{ |k,v| %| #{k}=#{v.inspect}| }.join("") + " ?>"
  end
end