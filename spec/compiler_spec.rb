require 'spec_helper'

describe Jader::Compiler do
  before :each do
    @compiler = Jader::Compiler.new
  end

  it "should respect default options" do
    @compiler.options.should == {
      :client => true,
      :compileDebug => false
    }
  end

  it "should define Jade.JS compiler version" do
    @compiler.jade_version.should == "0.27.6"
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