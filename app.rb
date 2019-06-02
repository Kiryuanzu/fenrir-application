require 'sinatra/base'
require 'sinatra/reloader'
require 'open-uri'
require 'json'
require 'byebug'
require 'dotenv/load'
require 'kaminari/sinatra'
require 'padrino-helpers'
require 'active_support/all'

class MyApp < Sinatra::Base
  register Kaminari::Helpers::SinatraHelpers

  get '/' do
    @title = "タイトル画面"
    erb :index
  end

  get '/search' do
    url = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=" + ENV["GNAVI_API_KEY"]
    url = url + "&latitude=" + params[:present_latitude]
    url = url + "&longitude=" + params[:present_longitude]
    url = url + "&range=" + params[:range]
    response = open(url).read
    response_hash = JSON.parse(response, { symbolize_names: true })
    @rest_list = Kaminari.paginate_array(response_hash[:rest]).page(params[:page]).per(5)
    erb :search
  end

  get '/show' do
    url = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=" + ENV["GNAVI_API_KEY"]
    url = url + "&id=" + params[:rest_id]
    response = open(url).read
    response_hash = JSON.parse(response, { symbolize_names: true })
    @rest = response_hash[:rest][0]
    erb :show
  end
end

MyApp.run! :host => 'localhost', :port => 4567