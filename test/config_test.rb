require File.dirname(__FILE__) + '/test_helper.rb'

require 'lib/cargo/config'

class Cargo::ConfigTest < Test::Unit::TestCase
  
  def setup
    Cargo::Config.any_instance.stubs(:get_file_data).returns(true)
  end
  
  def test_create
    config = Cargo::Config.new(true)
    config.api_key = '12345'
    config.project = '54321'
    
    assert config.integrate_with_tracker
    assert config.api_available?
  end
end