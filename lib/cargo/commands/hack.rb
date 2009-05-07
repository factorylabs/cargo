require "#{File.dirname(__FILE__)}/base.rb"
module Cargo
  module Commands
    class Hack < Cargo::Commands::Base
      attr_accessor :story, :story_number, :story_name
      
      def story_name=(val)
        @story_name = /\s|\.|\\|\// =~ val ? escape(val)[0..30] : val
      end
      
      def topic_name
        if self.story_number 
          "#{self.story_name}-#{self.story_number}" 
        else
          self.story_name || default_topic_name
        end
      end
      
      def run(args)
        refresh_master

        if !args.empty?
          self.story_name = args[0]
        end
        
        if args.length > 1
          self.story_number = args[1]
        else
          get_story_from_user 
        end

        cmd "git checkout -b #{topic_name}"
        
        begin
          self.story.current_state = 'started'
          self.story.save
        rescue ActiveResource::ServerError => e
          # puts e
          puts  "unable to set story to started on tracker"
        end
      end
      
      def default_topic_name
        total = `git branch`.scan("story").size
        if total == 0
          default = "story"
        else
          default = "story_#{total + 1}"
        end
      end
      
      def get_story_from_user
        if Cargo::Config.api_available?
          stories = fetch_stories
          choice = Readline.readline "Enter story number or type custom name: "
          if !choice.empty? && choice.to_i.to_s == choice
            self.story = stories[choice.to_i + 1] 
            self.story_name ||= self.story.name
            self.story_number = self.story.id.to_s
          else
            self.story_name = choice
          end
        else
          self.story_name = Readline.readline "Topic name (#{default}): "
        end
      end
      
      def fetch_stories
        puts "Fetching tracker stories"
        stories = current_project.stories(:filter => 'state:unstarted', :limit => 5)
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