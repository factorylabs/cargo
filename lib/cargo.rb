$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))
  

module Cargo
  VERSION = '0.0.2.7'

  class Error < RuntimeError
  end

end
