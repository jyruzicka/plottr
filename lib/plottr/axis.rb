class Plottr::Axis
  # Axes are renderable
  include Plottr::Renderable

  #Which plot does this axis belong to?
  attr_accessor :plot

  # Which aesthetic are we mapping here? Normally x or y
  attr_accessor :aesthetic
  ALLOWED_AESTHETICS = %i(x y)

  attr_accessor :label

  # Initialize an axis
  def initialize(plot, aesthetic)
    self.plot = plot
    self.aesthetic = aesthetic
  end

  def aesthetic= aes
    raise ArgumentError, "Aesthetic must be one of #{ALLOWED_AESTHETICS}" unless ALLOWED_AESTHETICS.include?(aes)
    @aesthetic = aes
  end

  def converter
    plot.converter(aesthetic)
  end

  def render
    coord_from = [plot.margin[:left], plot.height - plot.margin[:bottom]]
    coord_to = case aesthetic
    when :x
      [plot.width - plot.margin[:right], plot.height - plot.margin[:bottom]]
    when :y
      [plot.margin[:left], plot.margin[:top]]
    end
      
    # 1. Draw baseline
    plot.add_line(from: coord_from, to: coord_to)

    # 2. Draw tics
    tics.each do |t|
      delta = converter[t]
      tic_start = on_axis(delta)
      tic_end = on_axis(delta, 5)
      plot.add_line(from: tic_start, to: tic_end)
      plot.add_text(at: on_axis(delta, 15), text: t, anchor: :middle, size: 10, dy: 3)
    end

    # 3. Draw label
    range = converter.range
    midpoint = (range.end - range.begin) / 2 + range.begin

    plot.add_text(at: on_axis(midpoint, 35), text: label, anchor: :middle, size: 14, rotate: label_rotation)
  end

  def tics
    if converter.discrete_domain?
      converter.domain
    else # Continuous domain
      domain = converter.domain
      gap = domain.end - domain.begin
      best_fit = (4..10).to_a.reverse.find{ |i| gap % i == 0 }
      best_fit ||= 5

      delta = gap.to_f / best_fit
      tics = (0..best_fit).map{ |i| domain.begin + delta * i }

      if tics.all?{ |t| t.to_i == t }
        return tics.map{ |t| t.to_i }
      else
        return tics
      end
    end
  end

  def on_axis(axis_offset, off_axis=0)
    case aesthetic
    when :x
      [axis_offset, plot.height - plot.margin[:bottom] + off_axis]
    when :y
      [plot.margin[:left] - off_axis, axis_offset]
    end
  end

  def label_rotation
    {x: 0, y: -90}[aesthetic]
  end

  def label
    @label || plot.property_for_aesthetic(self.aesthetic)
  end
end