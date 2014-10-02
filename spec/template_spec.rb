require 'spec_helper'
require 'fileutils'
describe Jader::Compiler do

  before :all do
    d = Rails.root.join('tmp','cache','assets')
    FileUtils.rm_r d if Dir.exists? d
  end

  def template(source, file)
    Jader::Template.new(file){source}
  end

  it 'should have default mime type' do
    Jader::Template.default_mime_type.should == 'application/javascript'
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
    context.eval('html').should == "<!DOCTYPE html><head><title>Hello, Yorik :)</title></head><body>Yap, it works</body>"
  end

  it 'should use mixins in JST' do
    phrase = 'Hi There'
    context = ExecJS.compile %{
      #{asset_for('application.js').to_s}
      html = JST['views/users/dummy']({phrase: '#{phrase}'})
    }
    context.eval('html').should include(phrase.upcase)
  end

end
