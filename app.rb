$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'speedline'

class SpeedLineApp < Sinatra::Base
  configure :development do
    Bundler.require :development
    register Sinatra::Reloader
  end

  get "/" do
    send_file File.join('index.html')
  end

  get "/process" do
    url = params[:url]
    unless url
      halt 400, 'url required'
    end

    content_type 'image/gif'

    cache = Dalli::Client.new

    content = cache.get(url)
    return content if content

    content = SpeedLine.new.apply_for_url(url)

    cache.set(url, content, 3600*24)

    content
  end

end
