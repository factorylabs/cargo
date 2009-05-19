require 'rubygems'
require 'readline'
require 'pp'
require 'pickler'

require "#{File.dirname(__FILE__)}/../config.rb"

module Cargo
  module Commands
    class Base
      attr_accessor :current_project
      
      def setup
        @config = get_config
        
        if @config.integrate_with_tracker
          @tracker = Pickler::Tracker.new(@config.api_key, :false)
        
          unless @config.project
            @config.project = grab_project_id_from_user
            @config.write_project
          end

          @current_project = Pickler::Tracker::Project.new(@tracker,@tracker.get_xml("/projects/#{@config.project}")["project"])
        end
      end
      
      def initialize(args)
        setup
        run(args)
      end
      
      def run(args)
      end
      
      def get_config
         Cargo::Config.new(true)
      end
      
      def grab_project_id_from_user
        response = @tracker.get_xml("/projects")

        projects = [response["projects"]].flatten.compact.map {|s| Pickler::Tracker::Project.new(@tracker,s)}

        puts 'Please choose a tracker project for the current directory'
        projects.each_with_index do |project, i|
          puts "#{i+1}) #{project.name}"
        end
        choice = Readline.readline "Enter: "
        projects[choice.to_i - 1].id
      end
      
      def current_branch
        `git branch | grep "*"`.strip[2..-1]
      end

      def checkout_branch(branch)
        cmd "git checkout #{branch}"
      end

      def merge_with_master(branch=current_branch)
        checkout_branch "master"
        cmd "git merge #{branch}"
      end

      def refresh_master
        checkout_branch "master"
        cmd "git pull origin master"
      end

      def cmd(input)
        result = `#{input}`
        puts result
        if $?.exitstatus > 0
          puts "Cargo (#{input}) failed, exiting. [#{$?.exitstatus}]"
          exit 1
        end
        result
      end

      def compare_git_ver
        m = /git version (\d+).(\d+).(\d+)/.match(`git version`.strip)
        return true  if m[1].to_i > 1
        return false if m[1].to_i < 1
        return true  if m[2].to_i > 5
        return false if m[2].to_i < 5
        return true  if m[3].to_i >= 3
        return false
      end

      def check_git_ver
        raise "Invalid git version, use at least 1.5.3" unless compare_git_ver
      end
    end
  end
end