module Cargo
  class Config
    cattr_accessor :api_key, :project, :integrate_with_tracker
    @@integrate_with_tracker = true
    
    def self.api_available?
      self.api_key && self.project && self.integrate_with_tracker
    end
  end
end