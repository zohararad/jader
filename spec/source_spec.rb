require 'spec_helper'

describe Jade::Source do
  it "should contain jade asset" do
    File.exist?(Jade::Source::jade_path).should be_true
  end

  it "should contain runtime asset" do
    File.exist?(Jade::Source::runtime_path).should be_true
  end

  it "should be able to read jade source" do
    IO.read(Jade::Source::jade_path).should_not be_empty
  end

  it "should be able to read runtime source" do
    IO.read(Jade::Source::runtime_path).should_not be_empty
  end
end