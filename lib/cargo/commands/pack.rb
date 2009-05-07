require "#{File.dirname(__FILE__)}/base.rb"
module Cargo
  module Commands
    class Pack < Cargo::Commands::Base
      
      def run(args)
        merge_with_master
      end
      
    end
  end
end