# Represents an SVG object of some sort
class Plottr::Object
  include Plottr::Taggable

  def self.tag_type tt=nil
    tt  ? @tag_type = tt : @tag_type
  end

  def self.options *args
    args.empty?  ? @options : @options = args
  end

  def self.inside_element &blck
    blck ? @inside_element = blck : @inside_element
  end

  def initialize(hsh={})
    hsh.each do |k,v|
      setter = "#{k}="
      if self.respond_to?(setter)
        self.send(setter, v)
      else
        raise ArgumentError, "Unrecognised method #{setter} for #{self}."
      end
    end
  end
  
  def to_svg
    opts_hash = {}
    self.class.options.each do |opt|
      html_tag, object_method = if opt.is_a?(Hash)
        [opt.keys.first, opt.values.first]
      else
        [opt, opt]
      end

      if (val = self.send(object_method))
        opts_hash[html_tag] = val
      end
    end

    if self.class.inside_element
      tag(self.class.tag_type, opts_hash){ instance_exec &self.class.inside_element }
    else
      tag(self.class.tag_type, opts_hash)
    end
  end
end