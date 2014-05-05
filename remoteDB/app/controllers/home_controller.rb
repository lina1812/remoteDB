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
					u.u_type=(i.split(' ')[1].to_i-1).to_s
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
					u.u_type=params['users'][i.to_s]
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
				u.u_type=params['users'][i.to_s]
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
					u.u_type=(i.split(' ')[1].to_i-1).to_s
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
