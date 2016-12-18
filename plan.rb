# encoding: utf-8
require 'rubygems'
require 'sinatra/json'
require 'sinatra'
require 'sinatra/reloader'
require 'pg'
require 'active_record'
require 'json'
require 'date'
require 'sinatra/activerecord'

ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection(:production)

class Plans < ActiveRecord::Base
end

get '/' do
  erb :index
end

post '/send_plan' do

year = params[:year].to_s
month = params[:month].to_s
day = params[:day].to_s
today = year + "年" + month + "月" + day + "日"
message = params[:message]

plan = Plans.new({date: today, message: message})
plan.save
erb :index
end

post '/todays_plan' do
  today = params[:today].to_s
  message = ""
  message_data = Plans.where(:date => today).select("message").to_json
  message_check = message_data.to_s

  if message_check == "[]"
    message = "特にありません。"
  else
    message = message_data.slice!(1..-2).delete!("\"{}")
    message = message.delete!("message:") + "。以上となっています。"
  end

end
