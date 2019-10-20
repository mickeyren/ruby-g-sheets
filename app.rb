require 'sinatra'
require 'sinatra/namespace'
require 'sequel'

class Application < Sinatra::Base

end

namespace '/api' do
  before do
    content_type 'application/json'
  end

  get '/candidates' do
    DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://davidang:@localhost:5432/ruby-g-sheets') 
    dataset = DB[:users]
    
    dataset.insert(
      first_name: params[:first_name], 
      last_name: params[:last_name], 
      email: params[:email], 
      phone: params[:phone],
      timestamp: params[:timestamp])

    halt(200, { message: 'Hello World' }.to_json)
  end
end