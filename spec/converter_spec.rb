require_relative "spec_helper"

describe Plottr::Converter do

  let(:c){ Plottr::Converter.new }

  describe "#domain=" do
    it "should only accept a range or array" do
      c.domain = [1]
      c.domain = 2..7

      expect{ c.domain = 3 }.to raise_error(TypeError)
      expect{ c.domain = "a" }.to raise_error(TypeError)
      expect{ c.domain = nil }.to raise_error(TypeError)
    end
  end

  describe "#continuous_domain?" do
    it "should return true only when domain is a range" do
      expect(c.continuous_domain?).to eq(false)
      c.domain = [1]
      expect(c.continuous_domain?).to eq(false)
      c.domain = 0..1
      expect(c.continuous_domain?).to eq(true)
    end
  end

  describe "#discrete_domain?" do
    it "should return true only when domain is an array" do
      expect(c.discrete_domain?).to eq(false)
      c.domain = [1]
      expect(c.discrete_domain?).to eq(true)
      c.domain = 0..1
      expect(c.discrete_domain?).to eq(false)
    end
  end

  describe "#nil_domain?" do
    it "should return true only when domain is nil" do
      expect(c.nil_domain?).to eq(true)
      c.domain = [1]
      expect(c.nil_domain?).to eq(false)
      c.domain = 0..1
      expect(c.nil_domain?).to eq(false)
    end
  end

  describe "#discrete_range=" do
    it "should accept only Arrays or nil" do
      expect{ c.discrete_range = 3}.to raise_error(TypeError)
      expect{ c.discrete_range = 0..1}.to raise_error(TypeError)
      c.discrete_range = nil
      c.discrete_range = [1]
    end
  end

  describe "#continuous_range=" do
    it "should accept only Ranges or nil" do
      expect{ c.continuous_range = 3}.to raise_error(TypeError)
      expect{ c.continuous_range = [1,2]}.to raise_error(TypeError)
      c.continuous_range = nil
      c.continuous_range = (0..1)
    end
  end

  describe "#range=" do
    it "should shift Arrays into the discrete_range" do
      c.range = [1,2,3]
      expect(c.discrete_range).to eq([1,2,3])
    end

    it "should shift ranges into the continuous_range" do
      c.range = 0..10
      expect(c.continuous_range).to eq(0..10)
    end

    it "should error on any other class" do
      expect{ c.range = 3 }.to raise_error(TypeError)
      expect{ c.range = "foobar" }.to raise_error(TypeError)
      expect{ c.range = nil }.to raise_error(TypeError)
    end
  end

  describe "#range" do
    context "with a discrete domain" do
      it "should return the discrete range if present" do
        c.domain = [1,2,3]
        c.range = [4,5,6]
        c.range = 0..10

        expect(c.range).to eq([4,5,6])
      end

      it "should fall back to the continuous range" do
        c.domain = [1,2,3]
        c.range = 0..10

        expect(c.range).to eq(0..10)
      end
    end

    context "with a continuous domain" do
      it "should return the continuous range" do
        c.domain = 0..100
        c.range = [4,5,6]
        c.range = 0..10
        expect(c.range).to eq(0..10)
      end

      it "should fall back to nil otherwise" do
        c.domain = 0..100
        c.range = [4,5,6]
        expect(c.range).to eq(nil)
      end
    end

    context "with no domain" do
      it "should be nil" do
        expect(c.range).to eq(nil)
      end
    end
  end

  describe "#[]" do
    context "discrete->discrete" do
      it "should throw an error if the range is too small" do
        m = Plottr::Converter.new(domain: [1,2,3], range: [1])
        expect{ m[2] }.to raise_error(RuntimeError)
      end

      it "should throw an error if asked to look up a value it doesn't recognise" do
        m = Plottr::Converter.new(domain: [1,2,3], range: ["a","b","c"])
        expect{ m[4] }.to raise_error(ArgumentError)
      end

      it "should map 1:1 as required" do
        m = Plottr::Converter.new(domain: [1,2,3], range: ["a","b","c"])
        expect(m[1]).to eq("a")
        expect(m[3]).to eq("c")
      end
    end

    context "discrete->continuous" do
      it "should map appropriately onto a continous spectrum" do
        m = Plottr::Converter.new(domain: [1,2,3], range: 10..20)
        expect(m[1]).to eq(10)
        expect(m[2]).to eq(15)
        expect(m[3]).to eq(20)
      end
    end

    context "continuous->discrete" do
      it "should error" do
        m = Plottr::Converter.new(domain: 0..100, range: [:blue, :red, :green])
        expect{ m[0] }.to raise_error(RuntimeError)
      end
    end

    context "continuous->continuous" do
      it "should map continuous->continuous" do
        m = Plottr::Converter.new(domain: 0..10, range: 0..100)
        expect(m[0]).to eq(0)
        expect(m[3]).to eq(30)
        expect(m[10]).to eq(100)
      end
    end

    context "with rows" do
      it "should extract the value from the " do
        
      end
    end
  end

  describe "#expand_to_cover" do
    context "when the converter has a discrete domain" do
      it "should add to the array" do
        c.domain = ["a","d","b"]
        c.expand_to_cover("e")
        expect(c.domain).to eq(["a","d","b","e"])

        c.expand_to_cover("a")
        expect(c.domain).to eq(["a","d","b","e"])
      end

      it "should not allow Numeric values" do
        c.domain = ["a","b"]
        expect{ c.expand_to_cover(3) }.to raise_error(TypeError)
        expect{ c.expand_to_cover(1.2) }.to raise_error(TypeError)
      end
    end

    context "when the converter has a continuous domain" do
      it "should expand the domain" do
        c.domain = 0..10
        c.expand_to_cover(9)
        expect(c.domain).to eq(0..10)
        c.expand_to_cover(13)
        expect(c.domain).to eq(0..13)
        c.expand_to_cover(-2)
        expect(c.domain).to eq(-2..13)
      end

      it "should not allow non-numeric values" do
        c.domain = 0..10
        expect{ c.expand_to_cover(:a) }.to raise_error(TypeError)
        expect{ c.expand_to_cover("d") }.to raise_error(TypeError)
        expect{ c.expand_to_cover(nil) }.to raise_error(TypeError)
      end
    end

    context "when the converter has no domain" do
      it "should create a continuous domain converter if supplied a number" do
        c.expand_to_cover(3)
        expect(c.continuous_domain?).to be(true)
      end

      it "should create a range that includes zero" do
        c.expand_to_cover(3)
        expect(c.domain).to eq(0..3)
      end

      it "should create a discrete domain converter if supplied a non-number" do
        c.expand_to_cover(:foo)
        expect(c.discrete_domain?).to be(true)
      end
    end
  end
end