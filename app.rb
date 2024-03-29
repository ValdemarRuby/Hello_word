#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'pony'
require 'sqlite3'

def is_barber_exist? db, name
  db.execute('select * from Barbers where name=?', [name]).length > 0
end

def send_db db, barbers
  barbers.each do |barber|
    if !is_barber_exist? db, barber
      db.execute 'insert into Barbers (name) values (?)', [barber]
    end
  end
end

def get_db
 	return SQLite3::Database.new 'mydatabase.db'
end

before do
  db = get_db
  db.results_as_hash = true
  @barbers = db.execute 'select * from Barbers order by id'
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

    db.execute 'CREATE TABLE IF NOT EXISTS
    	"Barbers"
    	(
    		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
    		"name" TEXT
    	)'

      send_db db, ['Gus Friman', 'Walter White', 'Bob Pinkman', 'Mayk Downy']
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
  db = get_db
  db.results_as_hash = true
  @results = db.execute 'select * from Users order by id'
  erb :showusers
end
