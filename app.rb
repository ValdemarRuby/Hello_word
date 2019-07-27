#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School!!!</a>"
end


get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

post '/visit' do
	@username = params[:username]
	@phone = params[:phone]
	@date_time = params[:date_time]
	@barber = params[:barber]

	hash = { :username => 'Enter your name',
					 :phone => 'Enter your phone',
					 :date_time => 'Enter time'
	}

	hash.each do |key, value|
		if params[key] == ''
			@error = hash[key]
			return erb :visit
		end
	end
	erb "OK, username is #{@username}, #{@phone}, #{@date_time}, #{@barber}"
end
