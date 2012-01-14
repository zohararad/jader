require 'spec_helper'

describe Jade::Compiler do
  before :each do
    @compiler = Jade::Compiler.new
  end

  it "should respect default options" do
    @compiler.options.should == {
      :client => true,
      :compileDebug => false
    }
  end

  it "should contain ExecJS context" do
    @compiler.context.eval("window.jade").should_not be_empty
  end

  it "should define Jade.JS compiler version" do
    @compiler.jade_version.should == "0.20.0"
  end

  it "should compile small thing" do
    @compiler.compile('test').should include "<test>"
  end

  it "should depend on options" do
    @compiler.compile('test').should_not include "lineno: 1"
    @compiler.options[:compileDebug] = true
    @compiler.compile('test').should include "lineno: 1"
  end
end