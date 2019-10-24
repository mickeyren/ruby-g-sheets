require 'sinatra'
require 'sinatra/namespace'
require 'sequel'

require 'net/http'
require 'uri'
require 'json'

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

    # talkpush
    uri = URI.parse('https://my.talkpush.com/api/talkpush_services/campaigns/3929/campaign_invitations')

    header = { 'Cache-Control': 'no-cache', 'Content-Type': 'application/json' }
    data = {
      api_key: ENV['TALKPUSH_API_KEY'],
      api_secret: ENV['TALKPUSH_SECRET_KEY'],
      campaign_invitation: {
        first_name: params[:first_name],
        last_name: params[:last_name],
        email: params[:email],
        user_phone_number: params[:phone]
      }
    }

    # Create the HTTP objects
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.request_uri, header)
    request.body = data.to_json

    # Send the request
    response = http.request(request)

    halt(200, response.to_json)
  end
end