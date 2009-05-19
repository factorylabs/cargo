require "#{File.dirname(__FILE__)}/base.rb"
module Cargo
  module Commands
    class Ship < Cargo::Commands::Base
      
      def run(args)
        branch = current_branch
        merge_with_master(branch)
        cmd "git push origin master"
        cmd "git branch -d #{branch}"
        finish_story(branch.split('-').last) if @config.api_available?
      end
      
      def finish_story(story_id)
        story = Pickler::Tracker::Story.new(@current_project,@current_project.tracker.get_xml("/projects/#{@current_project.id}/stories/#{story_id}")["story"])      
        story.finish!
      end
      
    end
  end
end