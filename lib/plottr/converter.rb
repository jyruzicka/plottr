# Converts one series of values (the domain) to another (the range).
# Each series may be discrete (represented by a Range) or continuous
# (an array).
class Plottr::Converter
  # The array or domain of inputs over which the converter must map
  attr_accessor :domain

  # The array of discrete outputs the converter may use
  attr_accessor :discrete_range

  # The array of continuous outputs the converter may use
  attr_accessor :continuous_range

  # By default, converter has no domain or range.
  def initialize(domain:nil, range: nil)
    self.domain = domain if domain
    self.range = range if range
  end

  #---------------------------------------
  # Domain methods

  def domain= d
    raise TypeError, "Domain must be a Range or Array" unless [Range, Array].include?(d.class)
    @domain = d
  end

  def continuous_domain?
    @domain.is_a?(Range)
  end

  def discrete_domain?
    @domain.is_a?(Array)
  end

  def nil_domain?
    @domain.nil?
  end

  #---------------------------------------
  # Range methods

  # The converter can contain two different ranges:
  # * One for discrete domains
  # * One for continuous domains
  # If there is no discrete range, a continuous range may
  # be used in its place. If there is no continuous range,
  # a discrete range may *not* be used in its place.

  def discrete_range= r
    raise(TypeError, "Discrete range must be an Array.") unless r.is_a?(Array) or r.nil?
    @discrete_range = r
  end

  def continuous_range= r
    raise(TypeError, "Continuous range must be a Range.") unless r.is_a?(Range) or r.nil?
    @continuous_range = r
  end

  def range= r
    case r
    when Array
      self.discrete_range = r
    when Range
      self.continuous_range = r
    else
      raise TypeError, "Range must be a Range or Array."
    end
  end

  # Fetch the appropriate range, given the form of domain we have
  def range
    if discrete_domain?
      discrete_range || continuous_range
    elsif continuous_domain?
      continuous_range
    else
      nil
    end
  end

  #---------------------------------------
  # Conversion function
  def [] x
    raise RuntimeError, "Converter#[] called on a Converter with no domain." if nil_domain?

    if continuous_domain?
      # Cannot map continuous domain to discrete range!
      raise RuntimeError, "Converter contains no continuous range" if continuous_range.nil?
      x / domain * continuous_range

    else # discrete_domain
      raise RuntimeError, "Attempting to map discrete domain onto discrete range, but insufficient output values." if
          discrete_range && discrete_range.size < domain.size

      idx = domain.index(x)
      raise ArgumentError, "Value #{x} not contained by domain of Converter #{self}." if idx.nil?

      if discrete_range # Normally, we'd just map 1:1 onto discrete range...
        discrete_range[idx]

      elsif continuous_range # OK, fine, we'll map onto the continuous range
        fraction = idx.to_f / (domain.size-1)
        fraction * range
      else
        raise RuntimeError, "Converter contains no range"
      end
    end
  end

  #-------------------------------------------------------------------------------
  # Ensure that the current domain covers the given value. If not, expand until
  # it covers said value.
  #
  # By default, continuous domains will always cover 0.
  def expand_to_cover(v)
    if nil_domain?
      if v.is_a?(Numeric)
        @domain = 0..0
        expand_to_cover(v)
      else
        @domain = [v]
      end
    elsif discrete_domain?
      raise(TypeError, "Cannot assign continuous value to a discrete domain") if v.is_a?(Numeric)
      domain << v unless domain.include?(v)
    else
      raise(TypeError, "Cannot assign discrete value to a continuous domain") if !v.is_a?(Numeric)
      if v < domain.min
        self.domain = (v..domain.max)
      elsif v > domain.max
        self.domain = (domain.min..v)
      end
    end
  end

  def round_domain
    return if discrete_domain?
    new_domain = self.domain.to_sf(1)
    
    old_range = self.domain.max - self.domain.min
    new_range = new_domain.max - new_domain.min

    coverage = old_range.to_f / new_range.to_f
    new_domain = self.domain.to_sf(2) if coverage < 0.5

    self.domain = new_domain
  end
end