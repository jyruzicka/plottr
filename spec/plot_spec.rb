require_relative "spec_helper"

describe Plottr::Plot do
  describe "#initialize" do
    context "with a map" do
      it "should provide a map, but not a converter" do
        p = Plottr::Plot.new(map: {colour: :species})

        expect(p.map(:colour)).to eq(:species)
        expect(p.converter(:colour)).to eq(nil)
      end
    end
  end

  describe "#<<" do
    let(:plot){ Plottr::Plot.new }

    it "should accept a row of data when passed" do
      plot << Plottr::Row.new(name: "Foo", age: 35)
    end

    it "should accept a hash in place of data" do
      plot << {name: "Foo", age: 35}
    end
  end

  describe "#map" do
    it "should return the appropriate property mapped onto a given aesthetic" do
      p = Plottr::Plot.new(map: {foo: :bar})
      expect(p.map(:foo)).to eq(:bar)
    end

    it "should return nil when asking about an aesthetic with no mapping" do
      p = Plottr::Plot.new
      expect(p.map(:foo)).to eq(nil)
    end
  end

  describe "#has_map?" do
    it "should return true or false, appropriately" do
      p = Plottr::Plot.new(map: {foo: :bar})
      expect(p).to have_map(:foo)
      expect(p).to_not have_map(:bar)
    end
  end

  describe "#create_map" do
    it "should create a map" do
      p = Plottr::Plot.new
      p.create_map(:foo, :bar)
      expect(p).to have_map(:foo)
    end

    it "should override a currently existing map" do
      p = Plottr::Plot.new(map: {foo: :bar})
      p.create_map(:foo, :baz)
      expect(p.map(:foo)).to eq(:baz)
    end
  end

  describe ".set_range_for_aesthetic" do
    it "should error when not provided hash or block" do
      expect{ Plottr::Plot.set_range_for_aesthetic(:foo) }.to raise_error(ArgumentError)
    end

    it "should take a hash" do
      Plottr::Plot.set_range_for_aesthetic(:foo, {a: 1})
      expect(Plottr::Plot.range_for_aesthetic(:foo)).to eq({a: 1})
    end

    it "should take a block" do
      Plottr::Plot.set_range_for_aesthetic(:foo){ "Bar!" }
      expect(Plottr::Plot.range_for_aesthetic(:foo)[]).to eq("Bar!")
    end
  end

  describe "#property_for_aesthetic" do
    it "should pick the most common property" do
      p = Plottr::Plot.new  
      p.visuals = [:foo, :bar, :bar].map{ |s| double(map: s) }
      expect(p.property_for_aesthetic("whatever")).to eq(:bar)
    end

    it "should pick the first property, if tied for properties" do
      p = Plottr::Plot.new  
      p.visuals = [:foo, :bar, :bar, :foo].map{ |s| double(map: s) }
      expect(p.property_for_aesthetic("whatever")).to eq(:foo)
    end
  end
end