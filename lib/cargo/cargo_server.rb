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
    case env['PATH_INFO']

    when '/cargo.user.js' # send the user script file
      [200, {'Content-Type' => 'text/javascript'},
        File.read("#{File.dirname(__FILE__)}/../../files/cargo.user.js")]

    when '/start' # start a story
      puts "Starting Story..."
      [200, { 'Content-Type' => 'application/json; charset=utf-8', 'Access-Control-Allow-Origin' => '*'},
        {:success => {:title => 'Starting Story', :content => 'A new branch has been created for the "" story'}}.to_json]

    when '/finish' # finish a story
      puts "Finishing Story..."
      [200, {'Content-Type' => 'application/json; charset=utf-8'},
        {:success => {:title => 'Finishing Story', :content => 'The story being worked in will be merged, tested, and committed.  If everything goes well, this story will be marked as finished, otherwise you\'ll be notified.'}}.to_json]

    else # handle everything else like a 404
      [404, {'Content-Type' => 'text/html'}, '404 Not Found']

    end
  end
}, :Port => 8081
