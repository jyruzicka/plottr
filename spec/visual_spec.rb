require_relative "spec_helper"

class SampleVisual < Plottr::Visual
  requires_aesthetic :foo, :bar
  optional_aesthetic :baz, :bax
end

describe Plottr::Visual do
  describe "#valid?" do
    it "should return false if a visual does not contain every requires_map" do
      s = SampleVisual.new(map: {foo: 1})
      expect(s).to_not be_valid
    end

    it "should return true if a visual contains every requires_map" do
      s = SampleVisual.new(map: {foo: 1, bar: 2})
      expect(s).to be_valid
    end

    it "should return true if a visual contains every requires_map and some optional maps" do
      s = SampleVisual.new(map: {foo: 1, bar: 2, baz: 3})
      expect(s).to be_valid
    end

    it "should return false if a visual contains a non-required, non-optional map" do
      s = SampleVisual.new(map: {foo: 1, bar: 2, baz: 3, bux: 4})
      expect(s).to_not be_valid
    end

    it "should return true if required maps are contained by the plot" do
      p = double("Plot")
      expect(p).to receive(:has_map?).with(:bar).and_return(true)
      s = SampleVisual.new(map: {foo: 1})
      s.plot = p
      expect(s).to be_valid
    end
  end

  describe "#map" do
  end
end