require 'sinatra'

get '/' do
    'Hello World!'
end

post '/apify' do
    request.body.rewind
    request_payload = JSON.parse request.body.read
    if request_payload["eventType"]
        # "ACTOR.RUN.SUCCEEDED", "ACTOR.RUN.FAILED", "ACTOR.RUN.TIMED_OUT"
        # request_payload.dig("resource", "defaultDatasetId") 
        status 200
    else
        status 400
    end
end

# to access the sinatra server from a webhook use
# $ ngrok http 4567