require "#{File.dirname(__FILE__)}/base.rb"
module Cargo
  module Commands
    class Yank < Cargo::Commands::Base
      
      def run(args)
        branch = current_branch
        refresh_master
        cmd "git checkout #{branch}"
        was_dirty = stash_if_dirty
        cmd "git rebase master"
        apply_stash if was_dirty
      end
      
      def is_branch_dirty?
        status = `git status`
        /\#\s+modified\:/ =~ status  
      end
      
      def stash_if_dirty  
        dirty = is_branch_dirty?
        if dirty
          cmd "git stash"
        end
        dirty
      end

      def apply_stash
        stash_list = `git stash list`
        if /stash\@\{\d\}\:/ =~ stash_list
          cmd "git stash pop"
        end
      end
      
    end
  end
end