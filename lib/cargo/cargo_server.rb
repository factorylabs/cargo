require 'rubygems'
require 'rack'
require 'cargo'
require "#{File.dirname(__FILE__)}/command_helpers.rb"

puts "=> Starting Cargo #{Cargo::VERSION} on http://0.0.0.0:8081"
puts "=> Ctrl-C to shutdown server"
puts "** Cargo listening at 0.0.0.0:8081"

class CargoServer
  def call(env)
    if env['REQUEST_METHOD'] == 'OPTIONS'
      [200, {
        'Access-Control-Allow-Origin' => '*', # TODO get this working with restrictions
        'Access-Control-Allow-Methods' => 'GET, OPTIONS',
        'Access-Control-Allow-Headers' => 'X-Prototype-Version, X-Requested-With, Accept',
        'Access-Control-Max-Age' => '1728000',
        'Access-Control' => 'allow <*>'
        }, '']
    else
      req = Rack::Request.new(env)
      puts req.path_info
      case req.path_info

      when '/start' # start a story
        puts `hack #{escape(req['name'])[0..30]} #{req['id']}`
        notify("Starting Story", "Starting story '#{req['name']}' [#{req['id']}]", 0)
        
        [200, { 'Content-Type' => 'application/json; charset=utf-8'},
          "{success: 'starting story'}"]

      when '/finish' # finish a story
        branch = git_branch
        story_id = branch.split('-').last
        if story_id == req['id']
          puts `ship`
          notify("Finishing Story", "Finishing story '#{req['name']}' [#{req['id']}]", 0)
        else
          notify("Story id doesn't match current branch", "Story id doesn't match current branch '#{branch}' [#{req['id']}]", 1)
        end
        
        [200, {'Content-Type' => 'application/json; charset=utf-8'},
          "{success: 'finishing story'}"]

      when '/cargo.user.js' # send the user script file
        [200, {'Content-Type' => 'text/javascript'},
          File.read("#{File.dirname(__FILE__)}/../../files/cargo-greasemonkey.user.js")]

      else # handle everything else like a 404
        [404, {'Content-Type' => 'text/html'}, '404 Not Found']

      end
    end
  end
  
  def escape(name)
    name.gsub!(/\W+/, ' ') # all non-word chars to spaces
    name.strip!            # ohh la la
    name.downcase!         #
    name.gsub!(/\ +/, '_')
  end

  def notify(title, message, priority)
    puts message
    system "growlnotify -n Cargo --image ~/Library/Autotest/rails_ok.png -p #{priority} -m #{message} #{title}"
  end
end

Rack::Handler::Mongrel.run CargoServer.new, :Port => 8081
