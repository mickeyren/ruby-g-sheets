require 'sinatra'
require 'sinatra/namespace'
require 'sequel'
require 'net/http'
require 'uri'
require 'json'

DB = Sequel.connect(ENV['DATABASE_URL'] || 'postgres://davidang:@localhost:5432/ruby-g-sheets')

namespace '/api' do
  before do
    content_type 'application/json'
  end

  get '/candidates' do
    insert_record
    response = send_to_talkpush

    halt(200, response.to_json)
  rescue StandardError => e
    halt(500, e.message)
  end

  def insert_record
    dataset = DB[:users]
    dataset.insert(
      first_name: params[:first_name],
      last_name: params[:last_name],
      email: params[:email],
      phone: params[:phone],
      timestamp: params[:timestamp])
  end

  def send_to_talkpush
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

    response = http.request(request)

    return response
  end
end