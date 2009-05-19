require File.dirname(__FILE__) + '/test_helper.rb'

require 'lib/cargo/commands/base'

class Cargo::Commands::BaseTest < Test::Unit::TestCase

  def setup
    Cargo::Config.any_instance.stubs(:get_file_data).returns(true)
    config = Cargo::Config.new(true)
    config.api_key = '12345'
    config.project = '54321'
    Cargo::Commands::Base.any_instance.stubs(:get_config).returns(config)

    project_xml = {"project" => {"name"=>"Project test", "iteration_length"=>1, "week_start_day"=>"Monday", "point_scale"=>"0,1,2,4,8", "id"=>54321}}
    Pickler::Tracker.any_instance.stubs(:get_xml).returns(project_xml)
  end

  def test_create
    base = Cargo::Commands::Base.new([])
    assert base.current_project
    assert_equal 54321, base.current_project.id
  end

end