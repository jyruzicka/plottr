class Array
  def to_range
    (min..max)
  end
end

class Numeric
  # Returns the "maximum place value" for a number.
  # E.g. max_place for 2000 is 1000, max_place for 53 is 10.
  def max_place
    if self == 0
      1
    else
      10 ** Math.log(abs, 10).to_i
    end
  end

  # Returns the number, rounded to the appropriate number of significant figures
  def to_sf(sf)
    # Convert to float, divide by exponent, round, multiply by exponent
    exp = self.exponent - sf + 1
    float_value = self.to_f / (10 ** exp)
    return float_value.round * (10 ** exp)
  end

  # Return the "exponent" of the numeric. This is the power that a single-digit number would be
  # raised to to get close to the original value.
  def exponent
    self == 0 ? 0 : Math.log(self.abs,10).floor
  end

  # Returns the smallest one-significant-figure number that is larger (smaller, if <0) than thus number
  def envelope()
    exp_multiplier = max_place
    env = (abs / exp_multiplier + 1) * exp_multiplier
    env *= -1 if self < 0
    env
  end
end

class Fixnum
  alias_method :old_divide, :/
  alias_method :old_multiply, :*

  def / o
    if o.is_a? Range
      (self - o.begin).to_f / (o.end - o.begin)
    else
      old_divide o
    end
  end

  def * o
    if o.is_a? Range
      (o.end - o.begin) * self + o.begin
    else
      old_multiply o
    end
  end
end

class Float
  alias_method :old_divide, :/
  alias_method :old_multiply, :*

  def / o
    if o.is_a? Range
      (self - o.begin).to_f / (o.end - o.begin)
    else
      old_divide o
    end
  end

  def * o
    if o.is_a? Range
      (o.end - o.begin) * self + o.begin
    else
      old_multiply o
    end
  end
end

class Range
  def * o
    if o.is_a? Numeric
      o * self
    else
      raise TypeError, "Can only multiply ranges by numerics - tried to multiply by a #{o.class}"
    end
  end

  def to_sf(sf)
    exponent = [self.begin.exponent, self.end.exponent].max - sf + 1
    multiplier = 10 ** exponent
    
    low_limit = 0
    if self.begin < 0
      low_limit -=1 until (low_limit * multiplier <= self.begin)
    else
      low_limit += 1 while ((low_limit+1) * multiplier <= self.begin)
    end

    high_limit = 0
    if self.end < 0
      high_limit -=1 while ((high_limit-1) * multiplier >= self.end)
    else
      high_limit +=1 until (high_limit * multiplier >= self.end)
    end

    return (low_limit * multiplier)..(high_limit * multiplier)
  end
end