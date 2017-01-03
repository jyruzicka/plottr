require_relative "spec_helper"

describe Plottr::Column do
  describe "#type" do
    it "should throw an error if type is now one of Column::ALLOWED_TYPES" do
      Plottr::Column.new("foo", :string)
      expect{ Plottr::Column.new("bar", :weird) }.to raise_exception(TypeError)
    end
  end

  describe ".columns_from_hash" do
    it "should create an appropriate array of columns" do
      ca = Plottr::Column.columns_from_hash(Name: :string, Age: :number)
      expect(ca.first.name).to eq(:Name)
      expect(ca.last.type).to eq(:number)
    end
  end

  describe "#allows_value?" do
    it "should allow suitable numbers" do
      c = Plottr::Column.new(:Foo, :number)
      expect(c.allows_value?(3)).to eq(true)
      expect(c.allows_value?(3.5)).to eq(true)
      expect(c.allows_value?(nil)).to eq(true)
      expect(c.allows_value?("sggggg")).to eq(false)
      expect(c.allows_value?(:stuff)).to eq(false)
    end

    it "should allow suitable strings" do
      c = Plottr::Column.new(:Bar, :string)
      expect(c.allows_value?("Foobar")).to eq(true)
      expect(c.allows_value?(nil)).to eq(true)
      expect(c.allows_value?(3.5)).to eq(false)
      expect(c.allows_value?(3)).to eq(false)
      expect(c.allows_value?(:monr)).to eq(false)
    end
  end
end