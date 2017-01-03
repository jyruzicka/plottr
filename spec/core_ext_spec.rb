require_relative "spec_helper"

describe Array do
  describe "#to_range" do
    it "should produce a range, spanning minimum and maximum values" do
      arr = [1,2,7,4,7,2,0]
      range = arr.to_range
      expect(range.begin).to eq(0)
      expect(range.end).to eq(7)
    end
  end
end

describe Numeric do
  describe "#to_sf" do
    it "should round numbers to the appropriate amount of significant figures" do
      expect(103.to_sf(1)).to eq(100)
      expect(109.to_sf(2)).to eq(110)
      expect(103.to_sf(3)).to eq(103)


      expect(-57.to_sf(1)).to eq(-60)
      expect(-52.to_sf(1)).to eq(-50)
      expect((-40.9).to_sf(2)).to eq(-41)

      expect(0.00547.to_sf(1)).to be_within(0.001).of(0.005)
      expect(0.00547.to_sf(2)).to be_within(0.0001).of(0.0055)
      expect(0.00547.to_sf(3)).to be_within(0.00001).of(0.00547)
    end
  end

  describe "#exponent" do
    it "should determine the exponent of a number" do
      expect(42.exponent).to eq(1)
      expect(1.exponent).to eq(0)
      expect(103.exponent).to eq(2)
      expect(0.4.exponent).to eq(-1)
    end

    it "should give us a nice 0 for 0, even though that's false" do
      expect(0.exponent).to eq(0)
    end
  end
end

describe Fixnum do
  describe "#/" do
    it "should divide by a range to give a float - between min and max" do
      expect(5 / Range.new(0,10)).to eq(0.5)
      expect(3 / Range.new(2,4)).to eq(0.5)
    end
  end

end

describe Float do
  describe "#/" do
    it "should divide by a range to give a float - between min and max" do
      expect(1.5 / Range.new(0,2)).to eq(0.75)
      expect(3.0 / Range.new(2,4)).to eq(0.5)
    end
  end

  describe "#*" do
    it "should give a value a certain way along a range" do
      expect(0.5 * Range.new(2,4)).to eq(3)
    end
  end
end

describe Range do
  describe "#*" do
    it "should be transitive" do
      r = Range.new(2,4)
      expect(r * 0.5).to eq(3)
      expect(r * 2).to eq(6)
    end
  end

  describe "#to_sf" do
    it "should build a range where both extremes are the given SF, same exponent, and cover all members" do
      expect((1..10).to_sf(1)).to eq(0..10)
      expect((2..9).to_sf(1)).to eq(2..9)
      expect((12..103).to_sf(1)).to eq(0..200)
      expect((12..103).to_sf(2)).to eq(10..110)
    end
  end
end