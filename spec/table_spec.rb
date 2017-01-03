require_relative "spec_helper"

describe Plottr::Table do
  let(:t){ Plottr::Table.new }

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
  
end