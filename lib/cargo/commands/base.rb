require 'rubygems'
require 'readline'
require 'pp'
require 'pickler'

require "#{File.dirname(__FILE__)}/../../pivotal_tracker/pivotal_tracker.rb"

require "#{File.dirname(__FILE__)}/../config.rb"

module Cargo
  module Commands
    class Base
      attr_accessor :current_project
      
      def setup
        [File.expand_path('~/.cargo'), './.cargo'].each do |f|
          load f if File.exist? f
        end
        
        if Cargo::Config.integrate_with_tracker
          tracker = Pickler::Tracker.new(Cargo::Config.api_key, :false)

          unless Cargo::Config.project
            project_id = grab_project_id_from_user
            Cargo::Config.project = project_id
            File.open(File.expand_path('./.cargo'), 'a'){|file| file.write("\nCargo::Config.project = #{project_id}\n")}
          end
      
          project_id = Cargo::Config.project if Cargo::Config.api_available? 
          @current_project = Pickler::Tracker::Project.new(tracker,tracker.get_xml("/projects/#{project_id}")["project"])
        end
      end
      
      def initialize(args)
        setup
        run(args)
      end
      
      def run(args)
        pp current_project
        pp current_project.stories(:filter => 'state:unstarted', :limit => 5)
        # pp Pivotal::Story.find(:all, :params => {:current_state => 'unstarted', :project_id => current_project.id})
      end
      
      def grab_project_id_from_user
        projects = Pivotal::Project.find(:all)
        puts 'Please choose a tracker project for the current directory'
        projects.each_with_index do |project, i|
          puts "#{i+1}) #{project.name}"
        end
        choice = Readline.readline "Enter: "
        projects[choice.to_i - 1]
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