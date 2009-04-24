require 'rubygems'
require 'rack'
require 'cargo'

puts "=> Starting Cargo #{Cargo::VERSION} on http://0.0.0.0:8081"
puts "=> Ctrl-C to shutdown server"
puts "** Cargo listening at 0.0.0.0:8081"

Rack::Handler::Mongrel.run proc { |env|
  if env['REQUEST_METHOD'] == 'OPTIONS'
    [200, {
      'Access-Control-Allow-Origin' => '*',
      'Access-Control-Allow-Methods' => 'GET, OPTIONS',
      'Access-Control-Allow-Headers' => 'X-Prototype-Version, X-Requested-With, Accept',
      'Access-Control-Max-Age' => '1728000',
      'Access-Control' => 'allow <*>'
      }, '']
  else
    req = Rack::Request.new(env)
    case req.path_info

    when '/cargo.user.js' # send the user script file
      [200, {'Content-Type' => 'text/javascript'},
        File.read("#{File.dirname(__FILE__)}/../../files/cargo.user.js")]

    when '/start' # start a story
      puts "Starting story #{req['id']} [#{req['title']}]"
      [200, {'Content-Type' => 'application/json; charset=utf-8', 'Access-Control-Allow-Origin' => '*'},
        '']

    when '/finish' # finish a story
      puts "Starting story #{req['id']} [#{req['title']}]"
      [200, {'Content-Type' => 'application/json; charset=utf-8', 'Access-Control-Allow-Origin' => '*'},
        '']

    else # handle everything else like a 404
      [404, {'Content-Type' => 'text/html'},
        '404 Not Found']

    end
  end
}, :Port => 8081
