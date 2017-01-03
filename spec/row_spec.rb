require_relative "spec_helper"

describe Plottr::Row do
  describe "#initialize" do
    it "should allow us to init with key/value pairs" do
      row = Plottr::Row.new(name: "Fred")
      expect(row.values[:name]).to eq("Fred")
    end

    it "should allow us to init without an argument" do
      Plottr::Row.new
    end
  end

  describe "#[]" do
    it "should allow us to fetch using [] notation" do
      row = Plottr::Row.new(name: "Fred")
      expect(row[:name]).to eq("Fred")
    end

    it "should allow us to fetch with string keys" do
      row = Plottr::Row.new(name: "Fred")
      expect(row["name"]).to eq("Fred")
    end
  end

  describe "#[]=" do
    it "should allow us to set using []= notation" do
      row = Plottr::Row.new()
      row[:name] = "Fred"
      expect(row[:name]).to eq("Fred")
    end

    it "should allow us to set with string keys" do
      row = Plottr::Row.new
      row["name"] = "Fred"
      expect(row[:name]).to eq("Fred")
    end
  end

  describe "#keys" do
    it "should list keys" do
      row = Plottr::Row.new(name: "Fred")
      row["age"] = 35
      expect(row.keys).to eq([:name, :age])
    end
  end

  describe "#ensure_value_exists!" do
    it "should add a nil value if key does not exist" do
      r = Plottr::Row.new
      r.ensure_value_exists!(:name)
      expect(r.has_key? :name).to eq(true)
    end

    it "should not touch a value already set" do
      r = Plottr::Row.new(name: "Fred")
      r.ensure_value_exists!(:name)
      expect(r[:name]).to eq("Fred")
    end
  end

  describe "#matches_column?" do
    it "should return true for nil value" do
      r = Plottr::Row.new(name: "Fred")
      c = double("column", name: :number)
      expect(r.matches_column?(c)).to eq(true)
    end

    it "should check if the value matches" do
      r = Plottr::Row.new(name: "Fred")
      c = double("column", name: :name)
      expect(c).to receive(:allows_value?).with(r[:name]).and_return(true)
      expect(r.matches_column?(c)).to eq(true)
    end
  end
end