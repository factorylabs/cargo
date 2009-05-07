require "#{File.dirname(__FILE__)}/base.rb"
module Cargo
  module Commands
    class Ship < Cargo::Commands::Base
      
      def run(args)
        branch = current_branch
        merge_with_master(branch)
        cmd "git push origin master"
        cmd "git branch -d #{branch}"
        finish_story(branch.split('-').last) if Cargo::Config.api_available?
      end
      
      def finish_story(story_id)
        story = Pivotal::Story.find(:first, :params => {:story_id => story_id, :project_id => Cargo::Config.project})
        begin
          self.story.current_state = 'finished'
          self.story.save
        rescue ActiveResource::ServerError => e
          # puts e
          puts  "unable to set story to finished on tracker"
        end
      end
      
    end
  end
end