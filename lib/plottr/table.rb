# The Table object stores a set of Rows. It also ensures that each Row conforms to the Table's general
# layout (i.e. does not introduce any new columns, existing columns are the right sort).

Plottr::InvalidRowKeyError = Class.new(Exception)

class Plottr::Table
  

  # A list of columns and their types
  attr_accessor :columns

  # A list of rows
  attr_accessor :rows

  # Initialize
  def initialize(columns=nil)
    @columns = []
    @rows = []

    self.columns = columns if !columns.nil?
  end

  # Fetch a given column
  def column(column_name)
    self.columns.select{ |c| c.name == column_name }
  end

  # Setter for columns
  def columns= c
    # What could this be?
    case c
    when Plottr::Column
      @columns = [c]
    when Array
      raise TypeError, "Plottr::Table#columns= can take an array of Plottr::Columns only" unless c.all?{ |e| e.is_a? Plottr::Column }
      @columns = c
    when Hash
      @columns = Plottr::Column.columns_from_hash(c)
    else
      raise TypeError, "Plottr::Table#columns= takes an array of Plottr::Columns, or Hash, was passed a #{c.class}."
    end
  end

  # Add rows to table
  def << row
    # If row is a Hash, convert it to a Row. If it's not a Hash or Row, error
    case row
    when Hash
      row = Plottr::Row.new(row)
    when Plottr::Row
    else
      raise(TypeError, "Plottr::Table#<< only accepts Plottr::Rows (you passed a #{row.class}).")
    end

    # Test validity of data against columns, set to null when required
    self.columns.each do |c|
      row.ensure_value_exists!(c.name)
      if !row.matches_column?(c)
        raise TypeError, "Row value #{row[c.name].inspect} doesn't match column #{c.name}, expecting a #{c.type}."
      end
    end

    # Ensure we don't have any unhandled rows
    unhandled_rows = row.keys.select{ |k| column(k).nil? }
    if !unhandled_rows.empty?
      raise RuntimeError, "Unhandled rows added to table: #{unhandled_rows.map(&:to_s).join(", ")}."
    end

    # Finally, add
    self.rows << row
  end

  # Iterate through rows
  def each_row &blck
    rows.each(&blck)
  end

  # Collect a "vector" or column - an array of values taken from each row
  def vector(column_name)
    rows.map do |row|
      raise(Plottr::InvalidRowKeyError, "Unrecognised row key #{column_name}") if !row.has_key?(column_name)
      row[column_name]
    end
  end

  #-------------------------------------------------------------------------------
  # Table modifying methods

  # Return a table with the same columns, but whose rows have been filtered according to either
  # the supplied hash, or a supplied block
  def filter(hsh=nil, &blck)
    raise(ArgumentError, "Table#filter requires exactly one argument, 0 supplied.") if hsh.nil? && blck.nil?
    raise(ArgumentError, "Table#filter requires exactly one argument, 2 supplied.") if hsh && blck
    new_rows = if hsh
      self.rows.select do |row|
        hsh.all? do |k,v|
          raise(Plottr::InvalidRowKeyError, "Unrecognised row key #{k}") if !row.has_key?(k)
          row[k] == v
        end
      end
    else
      self.rows.select{ |row| blck[row] }
    end

    new_table = Plottr::Table.new(self.columns)
    new_table.rows = new_rows
    new_table
  end

  # Return a table with sorted rows, according to supplied keys
  def sort(*keys)
    sort_directions = {}
    asc_regexp = /(.*)_asc$/
    desc_regexp = /(.*)_desc$/
    keys.each_with_index do |key,key_index|
      key_as_string = key.to_s
      if m = asc_regexp.match(key_as_string)
        new_key = m[1].to_sym
        keys[key_index] = new_key
        sort_directions[new_key] = :asc
      elsif m = desc_regexp.match(key_as_string)
        new_key = m[1].to_sym
        keys[key_index] = new_key
        sort_directions[new_key] = :desc
      else
        sort_directions[key] = :asc
      end
    end

    key_size = keys.size
    new_rows = rows.sort do |x,y|
      compare = 0
      idx = 0
      while compare == 0 && idx < key_size
        key = keys[idx]
        raise(Plottr::InvalidRowKeyError, "Unrecognised row key #{key}") if !x.has_key?(key) || !y.has_key?(key)
        compare = if sort_directions[key] == :asc
          (x[key] <=> y[key])
        else
          (y[key] <=> x[key])
        end
        idx += 1
      end
      compare
    end
    new_table = Plottr::Table.new(self.columns)
    new_table.rows = new_rows
    new_table
  end
end