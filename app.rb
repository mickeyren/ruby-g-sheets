require 'sinatra'
require 'sinatra/namespace'

class Application < Sinatra::Base

end

namespace '/api' do
  before do
    content_type 'application/json'
  end

  get '/candidates' do
    halt(200, { message: 'Hello World' }.to_json)
  end
end