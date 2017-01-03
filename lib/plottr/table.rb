# The Table object stores a set of Rows. It also ensures that each Row conforms to the Table's general
# layout (i.e. does not introduce any new columns, existing columns are the right sort).

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
    raise ArgumentError, "Column named #{column_name.inspect} doesn't exist." unless column(column_name)
    rows.map{ |r| r[column_name] }
  end
end