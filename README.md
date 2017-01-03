# plottr

Plottr will one day be a ruby library that enables you to turn **raw data** into **beautiful plots**. It's based heavily on R's [ggplot](), with help from [gnuplot]() and [d3]().

Plottr is still in the early stages of development. Watch this space as I continue to add features!

## Installation

Install via rubygems:

```
gem install plottr
```

Require in your application:

```ruby
require "plottr"
```

## Making plots

### Quick reference

```ruby
require 'plottr'

t = Plottr::Table.new(Country: :string, Population: :number, Area: :num)

t << {Country: "New Zealand", Population: 4_745_930, Area: 268_021}
t << {Country: "Australia", Population: 24_317_000, Area: 7_692_024}
t << {Country: "United States", Population: 324_720_797, Area: 9_833_517}
t << {Country: "Japan", Population: 127_110_047, Area: 377_972}

p = Plottr::Plot.new(t)
p.margin = { top: 50, bottom: 50, left: 55, right: 10 }

p << Plottr::Scatter.new(map: {x: :Area, y: :Population})

p.x_axis.label = "Land area (m^2)"
p.title = "Population density of some countries"

p.save_as("pop_density.svg")
```

### Creating a plot

Before you can make a plot, you have to create it:

```ruby
p = Plottr::Plot.new
```

You can initialize a plot with data:

```ruby
p = Plottr::Plot.new(data_table)
```

What form can this data table take? Details in a bit!

### Adding visuals

Each graphical representation of data in `plottr` is a *visual*: think of them like `ggplot`'s geoms. Want to make a simple scatter plot? That's one visual. Want a scatter plot with a line of best fit through it? That's two visuals, laid on top of each other.

`plottr` currently recognises one visual:

* **Scatter**: a scatter-plot.

This will change in the future.

To add a visual to your plot, simple append it with the `<<` method:

```
p = Plottr::Plot.new(data_table)
p << Plottr::Scatter.new(map: (x: "Area", y: "Population", colour: "Continent"))
```

But wait! What's that argument for our scatter plot? Each visual must have a **mapping**, which draws connections between *properties* of the data (i.e. quantitative or categorical values) and *aesthetic values* on the graph itself (e.g. x and y position, colour, point shape or size). In the above example, we've told `plottr` to map the "Area" property onto the x axis, the "Population" property onto the y axis, and the "Continent" property onto the point's colour.

### Saving to file

Once you've created your plot, and appended your visuals to it, you can save it:

```ruby
p = Plottr::Plot.new(data_table)
p << Plottr::Scatter.new(map: (x: "Area", y: "Population", colour: "Continent"))
p.save_as("plot.svg")
```

Currently, this only supports SVG format.

## Reference

### Data tables

Data is stored in the  `Plottr::Table` class. Soon, you will be able to import straight from CSV or similar, right into a `Table`. For the mean time, you'll have to do it by hand:

```ruby
t = Plottr::Table.new("Country" => :string, "Population" => :number, "Area" => :number)
t << {"Country" => "New Zealand", "Population" => 4_745_930, "Area" => 268_021}
```

Here we first initialise a table with three columns. Each column must be marked as either `:string` or `:number`. We can then add rows to this table using the `<<` operator - here we add a hash, which will be converted internally into a `Plottr::Row`.

### Plot

The ``Plottr::Plot` is the foundation of your plot. 