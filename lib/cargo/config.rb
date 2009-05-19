require 'yaml'

module Cargo
  class Config
    attr_accessor :api_key, :project, :integrate_with_tracker
    
    def initialize(integrate_with_tracker)
      @integrate_with_tracker = integrate_with_tracker
      get_file_data
    end

    def get_file_data
      raise "No api key in ~/.cargo.yml" unless File.exists? File.expand_path('~/.cargo.yml')
      config = YAML.load_file(File.expand_path('~/.cargo.yml'))
      @api_key = config["api_key"] if config
      raise "No api key in ~/.cargo.yml" if @api_key.nil?
      config = YAML.load_file('.cargo.yml') if File.exists? '.cargo.yml'
      @project = config["project"] if config
    end

    def write_project
      raise "No project id is set" unless @project
      File.open(File.expand_path('./.cargo.yml'), 'a'){|file| file.write("\nproject: #{@project}\n")}
    end    

    def api_available?
      @api_key && @project && @integrate_with_tracker
    end
  end
end