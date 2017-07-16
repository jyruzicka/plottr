require_relative "spec_helper"

describe Plottr::Table do
  let(:t){ Plottr::Table.new }

  let(:table) do
    t = Plottr::Table.new(Name: :string, Age: :number)
    t.rows = [
      {Name: "Joseph", Gender: "male", Age: 30},
      {Name: "Mark", Gender: "male", Age: 26},
      {Name: "Rachel", Gender: "female", Age: 24},
      {Name: "Mary", Gender: "female", Age: 26}
    ]
    t
  end

  describe "#columns=" do
    it "should be fine with a single column" do
      t.columns = Plottr::Column.new("Name", :string)
    end

    it "should be fine with an array of single columns" do
      t.columns = [
        Plottr::Column.new("Name", :string),
        Plottr::Column.new("Age", :number)
      ]
    end

    it "should be fine with a hash" do
      t.columns = {"Name" => :string, "Age" => :number }
    end

    it "should not be fine with anything else" do
      expect{ t.columns = 3 }.to raise_exception(TypeError)
      expect{ t.columns = ["strings"] }.to raise_exception(TypeError)
      expect{ t.columns = t }.to raise_exception(TypeError)
    end
  end

  describe "#<<" do
    it "should not accept anything other than a Hash or Plottr::Row" do
      expect{ t << 3 }.to raise_exception(TypeError)
    end

    it "should accept a Row object" do
      table = Plottr::Table.new(Name: :string, Age: :number)
      table << Plottr::Row.new(Name: "Fred", Age: 35)
    end
  end

  describe "#vector" do
    it "should pass back a list of values, in order, for the column" do
      expect(table.vector(:Name)).to eq(%w(Joseph Mark Rachel Mary))
    end

    it "should error when a non-existant column is supplied" do
      expect{ table.vector(:DNE) }.to raise_error(Plottr::InvalidRowKeyError)
    end
  end

  #---------------------------------------
  # Table alteration methods


  describe "#filter" do
    it "should filter by hash (one key)" do
      t = table.filter(Name: "Joseph")
      expect(t.class).to eq(Plottr::Table)
      expect(t.vector(:Name)).to eq(["Joseph"])

      t = table.filter(Name: "Liz")
      expect(t.rows).to be_empty
    end

    it "should filter by AND hash (two keys)" do
      t = table.filter(Gender: "male", Age: 26)
      expect(t.vector(:Name)).to eq(["Mark"])
    end

    it "should filter by proc" do
      t = table.filter{ |r| r[:Age] > 26 }
      expect(t.vector(:Name)).to eq(["Joseph"])
    end

    it "should complain if you send it a hash with a key it doesn't recognise" do
      expect{ table.filter(Foobar: "Bar") }.to raise_error(Plottr::InvalidRowKeyError)
    end

    it "should error when passed a hash and a Proc" do
      expect{ table.filter({}){} }.to raise_error(ArgumentError)
    end

    it "should error when not passed anything" do
      expect{ table.filter }.to raise_error(ArgumentError)
    end      
  end

  describe "#sort" do
    it "should sort by one key, ascending, by default" do
      t = table.sort(:Age)
      expect(t.rows.first[:Name]).to eq("Rachel")
    end

    it "should sort by two keys, both ascending" do
      t = table.sort(:Age, :Name)
      expect(t.vector(:Name)).to eq(%w(Rachel Mark Mary Joseph))
    end

    it "should sort by explicitly ascending and descending keys" do
      t = table.sort(:Age_asc, :Name_desc)
      expect(t.vector(:Name)).to eq(%w(Rachel Mary Mark Joseph))
    end
  end

  describe "#columns" do
    it "should " do
      
    end
  end
end