require 'rubygems'
require 'rack'
require 'cargo'

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
      case req.path_info

      when '/start' # start a story
        puts "Starting Story [#{req['id']}]..."
        notify("Starting Story", "Starting story '#{req['name']}' [#{req['id']}]", 0)
        # run command
        [200, { 'Content-Type' => 'application/json; charset=utf-8'},
          "{success: 'starting story'}"]

      when '/finish' # finish a story
        puts "Finishing Story [#{req['id']}]..."
        notify("Finishing Story", "Finishing story '#{req['name']}' [#{req['id']}]", 0)
        # run command
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

  def notify(title, message, priority)
    system "growlnotify -n Cargo --image ~/Library/Autotest/rails_ok.png -p #{priority} -m #{message} #{title}"
  end
end


Rack::Handler::Mongrel.run CargoServer.new, :Port => 8081
#Rack::Handler::Mongrel.run proc { |env| }, :Port => 8081

