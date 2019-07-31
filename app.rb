#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'
require 'sqlite3'


def get_db
 	return SQLite3::Database.new 'mydatabase.db'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
		"Users"
		(
			"id" INTEGER PRIMARY KEY AUTOINCREMENT,
			"username" TEXT,
			"phone" TEXT,
			"datastamp" TEXT,
			"barber" TEXT,
			"color" TEXT
			)'
end

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
	@datastamp = params[:date_time]
	@barber = params[:barber]

	hash = { :username => 'Enter your name',
					 :phone => 'Enter your phone',
					 :date_time => 'Enter time'
	}

	@error = hash.select {|key, value| params[key] == ''}.values.join(', ')

	if @error != ''
			return erb :visit
	end
  db = get_db
	db.execute 'insert into
		Users
		(
			username,
			phone,
			datastamp,
			barber,
			color
		)
		values (?, ?, ?, ?, ?)', [@username, @phone, @datastamp, @barber, @color]

	erb "OK, username is #{@username}, #{@phone}, #{@datastamp}, #{@barber}"
end

get '/contacts' do
	erb :contacts

end

post '/contacts' do
  unless params[:name] == '' || params[:email] == '' || params[:content] == ''
    Pony.options = {
      :subject => "Portfolio page: Message delivery from #{params[:name]}",
      :body => "#{params[:content]}",
      :via => :smtp,
      :via_options => {
        :address              => 'smtp.1and1.com',
        :port                 =>  '587',
        :enable_starttls_auto => true,
        :user_name            => ENV["wings6928"],
        :password             => ENV["Sommelier0955009"],
        :authentication       => :login,
        :domain               => 'nterrafranca.com'
        }
      }
    Pony.mail(:to => ENV["wings6928@gmail.com"])
    save_message(params[:name], params[:email], params[:content])
  end
  redirect '/'
end

get '/showusers' do

end

# post '/contacts' do
#
# 	unless params[:name] == '' || params[:message] == ''
# 		Pony.mail(
#    		:name => params[:name],
#   		:mail => params[:mail],
#   		:body => params[:body],
#   		:to => 'wings6928@gmail.com',
#   		:subject => params[:name] + " has contacted you",
#   		:body => params[:message],
#   		:port => '587',
#   		:via => :smtp,
#   		:via_options => {
#     		:address              => 'smtp.gmail.com',
#     		:port                 => '587',
#     		:enable_starttls_auto => true,
#     		:user_name            => 'wings6928',
#     		:password             => 'Sommelier0955009',
#     		:authentication       => :plain,
#     		:domain               => 'localhost.localdomain'
#   		})
# 			Pony.mail(:to => ENV["wings6928@gmail.com"])
# 	 save_message(params[:name], params[:email], params[:content])
# 	end
# 	redirect '/success'
# end
