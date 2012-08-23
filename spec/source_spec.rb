require 'spec_helper'

describe Jader::Source do
  it "should contain jade asset" do
    File.exist?(Jader::Source::jade_path).should be_true
  end

  it "should contain runtime asset" do
    File.exist?(Jader::Source::runtime_path).should be_true
  end

  it "should be able to read jade source" do
    IO.read(Jader::Source::jade_path).should_not be_empty
  end

  it "should be able to read runtime source" do
    IO.read(Jader::Source::runtime_path).should_not be_empty
  end
end