require 'spec_helper'

describe Jade::Compiler do
  before :all do
    # TODO: Clean dummy sprockets cache
  end

  def template(source, file)
    Jade::Template.new(file){source}
  end

  it 'should have default mime type' do
    Jade::Template.default_mime_type.should == 'application/javascript'
  end

  it 'should be served' do
    assets.should serve 'sample.js'
    asset_for('sample.js').body.should include "Yap, it works"
  end

  it 'should work fine with JST' do
    context = ExecJS.compile %{
      #{asset_for('application.js').to_s}
      html = JST['sample']({name: 'Yorik'})
    }
    context.eval('html').should == "<!DOCTYPE html><head><title>Hello, Yorik :)</title></head><body>Yap, it works\n</body>"
  end
end
