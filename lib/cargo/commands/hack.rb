require "#{File.dirname(__FILE__)}/base.rb"

module Cargo
  module Commands
    class Hack < Cargo::Commands::Base
      attr_accessor :story
      
      def run(args)
        refresh_master
        get_story(args[0])
        cmd "git checkout -b #{escape(self.story.name)}-#{self.story.id}"
        self.story.transition!('started')
      end
    
      def get_story(story_id)
        if story_id.blank?
          stories = fetch_stories
          choice = Readline.readline "Enter story number: "
          if !choice.empty? && choice.to_i.to_s == choice
            story_id = stories[choice.to_i - 1].id
          end
        end  
        
        raise 'Invalid story' if story_id.blank?
        self.story = Pickler::Tracker::Story.new(@current_project,@current_project.tracker.get_xml("/projects/#{@current_project.id}/stories/#{story_id}")["story"])      
      end
      
      def fetch_stories
        puts "Fetching tracker stories"
        stories = current_project.stories('state:unstarted')
        puts "Choose a story"
        stories.each_with_index do |story, i|
          puts "#{i+1}) #{story.name}"
        end
        stories
      end
      
      def escape(name)
        name.gsub!(/\W+/, ' ') # all non-word chars to spaces
        name.strip!            # ohh la la
        name.downcase!         #
        name.gsub!(/\ +/, '_')
      end
      
    end
  end
end