# The data row object stores values for plotting
class Plottr::Row
  # Stores values
  attr_accessor :values

  # Initialize with a hash of values
  def initialize(hsh={})
    @values = {}
    hsh.each{ |k,v| self[k] = v}
  end

  # Access values via [] notation
  def [] k
    @values[k.to_sym]
  end

  # Set values using [] notation
  def []= k,v
    @values[k.to_sym] = v
  end

  # List of value keys
  def keys
    @values.keys
  end

  # Identify if property exists in row
  def has_key? k
    @values.has_key?(k)
  end


  # If the value does not exist in our values hash, creates
  # it and sets it to null
  def ensure_value_exists!(k)
    @values[k] = nil unless @values.has_key?(k)
  end

  # Checks the row against a specified column. Returns `true` if the row contains
  # a passing value (or null), `false` if it does not.
  def matches_column?(c)
    if (value = self[c.name])
      return c.allows_value?(value)
    else
      return true
    end
  end
end