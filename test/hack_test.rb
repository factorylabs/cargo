require File.dirname(__FILE__) + '/test_helper.rb'

require 'lib/cargo/commands/hack'

class Cargo::Commands::HackTest < Test::Unit::TestCase

  def setup
    config = Cargo::Config.new(true)
    config.api_key = '12345'
    config.project = '54321'
    Cargo::Commands::Hack.any_instance.stubs(:get_config).returns(config)
    
    @tracker = Pickler::Tracker.new('78910', :false)
    @project_id = '54321'
    @project_xml = {"name"=>"Project test", "iteration_length"=>1, "week_start_day"=>"Monday", "point_scale"=>"0,1,2,4,8", "id"=>54321}
    @current_project = Pickler::Tracker::Project.new(@tracker,@project_xml)

    @story_id = '12345'
    @story_xml = {"story" => {"name"=>"Story test", "current_state"=>"unstarted", "requested_by"=>"Craig Partin", "url"=>"http://www.pivotaltracker.com/story/show/12345", "story_type"=>"bug", "id"=>12345, "description"=>nil, "created_at"=>"Mon Apr 27 17:48:26 UTC 2009"}}

    Cargo::Commands::Hack.any_instance.stubs(:cmd).returns(0) 
    Pickler::Tracker.any_instance.stubs(:get_xml).returns(@story_xml)
    Pickler::Tracker.any_instance.stubs(:request_xml).returns({})
  end

  def test_create_object
    hack = Cargo::Commands::Hack.new(["#{@story_id}"])
    assert_equal 12345, hack.story.id
    assert_equal 'started', hack.story.current_state
  end

end