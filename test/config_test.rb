require File.dirname(__FILE__) + '/test_helper.rb'

require 'lib/cargo/config'

class Cargo::ConfigTest < Test::Unit::TestCase
  
  def setup
    @config = Cargo::Config.new(true)
    @config.project = nil
  end
  
  def test_create
    assert @config.integrate_with_tracker
    assert @config.api_key
  end
end