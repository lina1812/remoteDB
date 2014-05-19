#!/usr/bin/env ruby
# coding: utf-8
#require  'open3'
require 'pg'
class HomeController < ApplicationController
	before_filter :authenticate_user!
  def start
  end
  def shell
  end
  def user_control_no_db
	@a=params.inspect
	if !params['is_commit'].nil?
		if !params['text'].nil?
			t=params['text']['text'].split("\r\n")
			@a=t.inspect
			t.each do |i|
				@a+=i
				if i!="" then
					u=User.new
					u.email=i.split(' ')[0]
					u.encrypted_password='000'
					u.group='1111'
					#@a+="<br>"+u.inspect
					u.save
				end
			end
		elsif !params['names'].nil? then
			params['names'].size.times do |i|
				if params['names'][i]!="" then
					u=User.new
					u.email=params['names'][i]
					u.encrypted_password='000'
					u.group='1111'
					#@a+="<br>"+u.inspect
					u.save
				end
			end
		end
	end
  end
  def text
	if !params['wysiwyg'].nil? then
		pass=params['wysiwyg']['password'].to_s
		
		@title='Результат:'
		message=params['wysiwyg']['text'].gsub('<p>',' ').gsub('</p>',' ').gsub('<br>'," \n")#.split('</p>')

		OtherDb.establish_connection(
			{ :adapter => 'postgresql',
				:database => 'test',
				:host => 'localhost',
				:username => 'test',
				:password => "0000" ,
				:port => "5436"}
				)
#		OtherDb.first
		@message=''#message.inspect+"\n"
#		message.each do |mes|
			result=OtherDb.connection.select_all(message)#.inspect
			@message+="\n"+result.columns.inspect+"\n"
			result.rows.each {|m| @message+=m.inspect+"\n"}
#		end
	else	
		@title='Введите запрос:'
		#@message=''
	end
  end

  def user_control
	@a=params.inspect
	@u=User.all
	OtherDb.establish_connection(
				{ :adapter => 'postgresql',
					:database => 'test',
					:host => 'localhost',
					:username => 'test',
					:password => "0000" ,
					:port => "5436"}
					)
	
	if !params['names'].nil? 
		params['names'].size.times do |i|
			if params['names'][i]!="" then
				u=User.new
				u.email=params['names'][i]
				u.encrypted_password='000'
				#@a+="<br>"+u.inspect
				u.save
				result=OtherDb.connection.select_all("CREATE USER " +params['names'][i]+" WITH encrypted PASSWORD 'qwerty';")#.inspect
				@a+="\n"+result.columns.inspect+"\n"
				result.rows.each {|m| @a+=m.inspect+"\n"}
			end
		end
	elsif !params['text'].nil?
		t=params['text']['text'].split("\r\n")
			@a=t.inspect
			t.each do |i|
				@a+=i
				if i!="" then
					u=User.new
					u.email=i.split(' ')[0]
					u.encrypted_password='000'
					#@a+="<br>"+u.inspect
					u.save
					result=OtherDb.connection.select_all("CREATE USER " +i.split(' ')[0]+" WITH encrypted PASSWORD 'qwerty';")#.inspect
					@a+="\n"+result.columns.inspect+"\n"
					result.rows.each {|m| @a+=m.inspect+"\n"}
				end
			end
	elsif !params['users'].nil?
		#u=User.find_by! email: 'radigin'
		params["users"].each do |k,w| 
			if w!="0" then
				u=User.find_by(email: k)
				if !u.nil? 
					u.destroy
					result=OtherDb.connection.select_all("DROP USER " +k+";")#.inspect
					@a+="\n"+result.columns.inspect+"\n"
					result.rows.each {|m| @a+=m.inspect+"\n"}
				end
			end
		end
	end
=begin	OtherDb.establish_connection(
				{ :adapter => 'postgresql',
					:database => 'test',
					:host => 'localhost',
					:username => 'test',
					:password => "0000" ,
					:port => "5436"}
					)
	
	if !params['users'].nil? then
		if params["user"]["action"]=="add"
			
#		OtherDb.first
		#@a=''#message.inspect+"\n"
#		message.each do |mes|
			params["users"].keys.each do |i|
				if params["users"][i]!="0" then
					result=OtherDb.connection.select_all("CREATE USER " +i.split('@')[0]+" WITH encrypted PASSWORD 'qwerty';")#.inspect
					@a+="\n"+result.columns.inspect+"\n"
					result.rows.each {|m| @a+=m.inspect+"\n"}
				end	
			end
		else
			params["users"].keys.each do |i|
				if params["users"][i]!="0" then
					result=OtherDb.connection.select_all("DROP USER " +i.split('@')[0]+";")#.inspect
					@a+="\n"+result.columns.inspect+"\n"
					result.rows.each {|m| @a+=m.inspect+"\n"}
				end
				
			end
		end
	
	
	end
=end
  end
  def bd_control
	@a=params.inspect
	@data_bases=[]
	conn = PG::Connection.new('localhost', 5436, nil, nil, nil, 'test', '0000')
	conn.exec("select datname from pg_database;") do |result|
			result.each do |row|
				@data_bases<<row["datname"]
			end
		end
		
	@users={}
	
	
			User.all.each do |row|
				@users[row['group']]=[] if @users[row['group']].nil?
				@users[row['group']]<<row['email']
				end

			
	end
	def a_search
		@a=params
		@login=[]
		@text=params['search']
		@text={} if @text.nil?
		if !params["search"].nil? then
			
		
			OtherDb.establish_connection(
				{ :adapter => 'postgresql',
					:database => 'test',
					:host => 'localhost',
					:username => 'test',
					:password => "0000" ,
					:port => "5436"}
					)
			if !params["search"]["is_student"].nil? then
				u=User.find_by(email: params['search']['email']) 
				u.is_student=params["search"]["is_student"] if  !params["search"]["is_student"] .nil?
				u.is_teacher=params["search"]["is_teacher"] if !params["search"]["is_teacher"].nil?
				u.is_admin=params["search"]["is_admin"] if !params["search"]["is_admin"].nil?
				u.save
			end
			if !params["search"]["encrypted_password"].nil? then
				if params['search']["encrypted_password"]!="" then
				#u=User.email
				#@a=""
					result=OtherDb.connection.select_all("ALTER USER " +params['search']['email']+" WITH encrypted PASSWORD '" +params['search']['encrypted_password']+"';")#.inspect
					#@a+="\n"+result.columns.inspect+"\n"
					#result.rows.each {|m| @a+=m.inspect+"\n"}
				end
			end
			if !params["search"]["delete"].nil? then
				#u=User.email
					#@a=""
					
					
				u=User.find_by(email: params['search']['email'])
				if !u.nil? 
					u.destroy
					result=OtherDb.connection.select_all("DROP USER " +params['search']['email']+";")#.inspect
					#@a+="\n"+result.columns.inspect+"\n"
					#result.rows.each {|m| @a+=m.inspect+"\n"}
				end
			end
			
			User.find_each do |u|
				if (params["search"]["login"]!=''?(!u.email[params["search"]["login"]].nil?):true &&
					params["search"]["name"]!=''?(!u.name[params["search"]["name"]].nil?):true &&
					params["search"]["surname"]!=''?(!u.surname[params["search"]["surname"]].nil?):true &&
					params["search"]["last_name"]!=''?(!u.last_name[params["search"]["last_name"]].nil?):true
					
					)
					@login<<u
				end
			end
		end
	end


	def a_regist
		@text=params['regist']
		@text={} if @text.nil?
		login=''
		@a=params
		if !params["regist"].nil? then
			
			if params['regist']['login']!="" then
			
				login=params['regist']['login']
			else
				s=params['regist']['surname'][0]
				n=params['regist']['name'][0]
				l=params['regist']['last_name'][0]
				
				login=to_t(s)+to_t(n)+to_t(l)
				m=''
				User.all.each do |i|
					m=i.email if (!i.email[login].nil? && m<i.email)
				end
				login+=(m.gsub(/[a-z]/,' ').split[-1].to_i+1).to_s
				#@message=login
			end
			
			if User.find_by(email: login).nil? then
					u=User.new
					u.email=login
					u.surname=params['regist']['surname']
					u.name=params['regist']['name']
					u.last_name=params['regist']['last_name']
					u.encrypted_password=params['regist']['encrypted_password']
					u.is_teacher=params['regist']['is_teacher'] if !params['regist']['is_teacher'].nil? 
					u.is_admin=params['regist']['is_admin'] if !params['regist']['is_admin'].nil? 
					u.save
					
					OtherDb.establish_connection(
					{ :adapter => 'postgresql',
						:database => 'test',
						:host => 'localhost',
						:username => 'test',
						:password => "0000" ,
						:port => "5436"}
						)
					result=OtherDb.connection.select_all("CREATE USER " +login+" WITH encrypted PASSWORD '"+params['regist']['encrypted_password']+"';")#.inspect
					@message= "Успешно зарегистрирован "+ (u.is_teacher=="1" ? u.is_admin=="1" ? "преподаватель и администратор " :"преподаватель ": u.is_admin=="1" ? "администратор " : "") + login +u.inspect
				else 
					@message=User.find_by(email: login).email # "Такой логин уже существует"
				end
		end
		
			
	end


	def to_t(c)
		translit={
		'Ц'=>'c',
		'У'=>'u',
		'К'=>'k',
		'Е'=>'e',
		'Н'=>'n',
		'Г'=>'g',
		'З'=>'z',
		'Х'=>'h',
		'Ш'=>'s',
		'Щ'=>'c',
		'Ф'=>'f',
		'В'=>'v',
		'А'=>'a',
		'П'=>'p',
		'Р'=>'r',
		'О'=>'o',
		'Л'=>'l',
		'Д'=>'d',
		'Ж'=>'z',
		'Э'=>'e',
		'Я'=>'y',
		'Ч'=>'c',
		'С'=>'s',
		'М'=>'m',
		'И'=>'i',
		'Т'=>'t',
		'Б'=>'b',
		'Ю'=>'y'
		}
		return translit[c].nil?? '':translit[c]
	end
	
  def a_mn_regist
	@a=params.inspect
	if !params['is_commit'].nil?
		if !params['regist'].nil?
			t=params['regist']['text'].split("\r\n")
			@a=''#t.inspect
			t.each do |i|
				
				j=i.split
				
					if j.size==7 
						if User.find_by(email: j[3]).nil? then
							u=User.new
							u.email=j[3]
							u.surname=j[0]
							u.name=j[1]
							u.last_name=j[2]
							u.is_teacher=j[4]
							u.is_admin=j[5]
							u.encrypted_password=j[6]
							@a=u.inspect
							u.save
							
							OtherDb.establish_connection(
							{ :adapter => 'postgresql',
								:database => 'test',
								:host => 'localhost',
								:username => 'test',
								:password => "0000" ,
								:port => "5436"}
								)
							result=OtherDb.connection.select_all("CREATE USER " + j[3]+" WITH encrypted PASSWORD '"+j[6]+"';")#.inspect
							@message="Успешно"
						else
							result=OtherDb.connection.select_all("ALTER USER " +j[3]+" WITH encrypted PASSWORD '" +j[6]+"';")#.inspect
					
						end
					else 
						@message="Некорректный ввод данных"
	#				if i!="" then
	#					a.email=i.split(' ')
	#				end
	#				r.inspect
					end
				
			end
		end
	end
  end
end


=begin		pgin,pgout,pgerr=Open3.popen3('psql -U test')
		message.each { |m|pgin.puts(m);}
		pgin.puts('\q');
		@message='' 
		pgout.readlines.map {|s| @message+=s}

		@message=''
		conn = PG::Connection.new('localhost', 5436, nil, nil, nil, 'test', pass)
		message.each do |m|
			conn.exec(m) do |result|
			result.each do |row|
				@message+=row.inspect+"\n"
				end

		end
		end
		conn.finish
=end
