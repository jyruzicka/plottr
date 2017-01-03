# The Column object represents a column in a table. It has a name, and a type.
class Plottr::Column
  # The name of the column
  attr_accessor :name

  # The type of the column
  attr_accessor :type

  # Verification procedures
  VERIFICATION = {
    string: lambda{ |val| val.is_a?(String) },
    number: lambda{ |val| val.is_a?(Numeric) }
  }

  # The allowed types the column may be
  ALLOWED_TYPES = VERIFICATION.keys



  # Initialize
  def initialize(name, type)
    self.name = name
    self.type = type
  end

  # Set name. Automatically converted to symbol
  def name= n
    @name = n.to_sym
  end

  # Set type. Must be one of ALLOWED_TYPES
  def type= t
    if ALLOWED_TYPES.include?(t)
      @type = t
    else
      raise TypeError, "Plottr::Column#type= only accepts #{ALLOWED_TYPES.map(&:to_s).join(", ")}."
    end
  end

  # Create an array of columns from a hash
  def self.columns_from_hash(hsh)
    hsh.map{ |k,v| Plottr::Column.new(k,v) }
  end

  # Checks a value against the given column. Returns `true` if this value
  # matches the chosen verification block.
  def allows_value?(v)
    v.nil? || VERIFICATION[self.type][v]
  end
end