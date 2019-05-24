require 'sinatra'
require 'sinatra/reloader'
require 'open-uri'
require 'json'
require 'byebug'
require 'dotenv/load'

get '/' do
  @title = "タイトル画面"
  erb :index
end

get '/search' do
  url = "https://api.gnavi.co.jp/RestSearchAPI/v3/?keyid=" + ENV["GNAVI_API_KEY"]

  url = url + "&latitude=" + params[:present_latitude]
  url = url + "&longitude=" + params[:present_longitude]
  url = url + "&range=" + params[:range]
  json = open(url)
  @list_hash = JSON.parse(json)
end
