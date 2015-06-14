#ruby remember
# $global_variable
# @@class_variable
# @instance_variable
# [OtherClass::]CONSTANT
# local_variable

#je customize le tout pour fonctionner avec siriproxy server
require 'rubygems'
require 'appscript'
require 'osax'
require 'net/ssh'
#partie sinatra, pour l interface http/ruby
require 'sinatra'
require 'sinatra/reloader' if development?

#non-essential
set :server, 'thin'

# 
# get '/connectconfig' do
# 	erb :server
# end
# 
# post '/setconnectconfig' do
# 	erb :server
# end





##test de la connection ( simple implŽmentation de appscript /osax et de quelques commandes en irb ) > works ! (> R : load sinatra ruby gem AFTER all others)
get '/test' do
	#bonjour appscript ?
	terminalApp = Appscript.app("/Applications/Utilities/Terminal.app")
	#terminalApp = Appscript.app("/Applications/iTerm.app")
	terminalApp.activate
	cmd = "say Knock knock" 
	system (cmd)
	`osascript -e 'tell application "System Events" to keystroke (ASCII character 110) using command down'`
	#optionnal fullscreening
	`osascript -e ' tell application "Terminal" to set bounds of window 1 to {0, 0, 1680, 1100}'`
	`osascript -e ' tell application "Terminal" to set position of window 1 to {0,0}'`
	# a tester: fullscreen terminal only ^^
	#`osascript -e ' tell application "Terminal" to set position of window 1 to {-20,-20}'` marche pas en hauteur > a tester: changer le z-index
	
	#et oui, jessaye davoir un output en provenance du terminal
	#Dir.chdir("/Users/stephaneadamgarnier") # a ne PAS faire ! > entre en conflict avec le currentDir de sinatra
	#Dir = "/Users/stephaneadamgarnier"
	#puts "The parent script starts off directory: #{Dir.pwd}"
	
	
	# generates an error when starting the server, but fine afterwards ?!
	
	#########
	shell_output = ""
	IO.popen('irb', 'r+') do |pipe|
  		pipe.puts("puts 'Hello world, from irb, inside of a Ruby script!'")
  		#files = `ls`
  		#pipe.puts files.split("\n").sort
  		pipe.close_write
  	shell_output = pipe.read
	end

	puts shell_output
	#########
	
	
	#`osascript -e 'tell app "Terminal" to do script "clear" in front window'`
	#`osascript -e 'tell app "Terminal" to do script "echo wakeup neo" in window 1'`
	`osascript -e 'tell application "System Events" to keystroke (ASCII character 87)'` #W
	`osascript -e 'tell application "System Events" to keystroke (ASCII character 97)'` #a
	`osascript -e 'tell application "System Events" to keystroke (ASCII character 107)'` #k
	`osascript -e 'tell application "System Events" to keystroke (ASCII character 101)'` #e
	`osascript -e 'tell application "System Events" to keystroke (ASCII character 117)'` #u
	`osascript -e 'tell application "System Events" to keystroke (ASCII character 112)'` #p
	
	`osascript -e 'tell application "System Events" to keystroke (ASCII character 32)'` #spacebar!
	
	`osascript -e 'tell application "System Events" to keystroke (ASCII character 78)'` #N
	`osascript -e 'tell application "System Events" to keystroke (ASCII character 101)'` #e
	`osascript -e 'tell application "System Events" to keystroke (ASCII character 111)'` #o
	
	erb :server
end

#test de la connection en ssh

	# partie configure , pr l instant en statique ()
	#set :host,"192.168.1.7"
	#set :password,"jackassapple"
	#set :password,"jackassapple"

#test de connection en ssh a un hote en local
get '/testconnectssh' do
	
	#static for the moment, we'll see later
	
	# test ssh connection,not from a local irb interpretor, but from a local server (at first) : FIRST (UNWORKING) TRY
	
	#HOST = '192.168.1.7'
	#USER = 'stephaneadamgarnier'
	#PASS = 'jackassapple'

	#Net::SSH.start( HOST, USER, :password => PASS ) do|ssh|
	#	output=ssh.exec!('ls -al')
	#	puts output
	#end
	#erb :server
	
	# test ssh connection,not from a local irb interpretor, but from a local server (at first) : SECOND TRY
	
	@hostname = "192.168.1.13"
	@username = "stephanegarnier"
	@password = "seedsdesign"
	@cmd = "ls -al" # list dir including hidden stuff
	@cmd = "say remote ssh connection from web interface up and running"
	
 	begin
    	ssh = Net::SSH.start(@hostname, @username, :password => @password)
    	res = ssh.exec!(@cmd)
    	ssh.close
    	puts res 
  	rescue
    	puts "Unable to connect to #{@hostname} using #{@username}/#{@password}"
  	end
  	
	erb :server
	
end # end of < get '/testconnectssh' do >


#on passe le chemin de la racine du site
get '/' do
	erb :home
end

get '/home' do
	erb :home
end

get '/index' do
	erb :index
end

get '/contact' do
	erb :contact
end

get '/server' do
	erb :server
end


#diffŽrents tests basiques en ruby/sinatra
get '/hello/:prenom' do
	erb :index
end

get '/form' do
	erb :form
end

post '/bonjour' do
	erb :bonjour
end

#DEBUG -> implŽmentation des variables de session

#session vars test1: simple version
get '/serverconfig' do
	#on spŽcifie une variable de session
	@title = 'Server configuration'
	#on spŽcifie la page (erb/haml) a afficher
	erb :serverconfig
end

#session vars test2: ( get+post> [same erb] ) version
get '/server/ssh' do
	#on spŽcifie une variable de session
	@title = 'SSH configuration'
	
	#test: recup des diffŽrentes vars de session
	@ssh_session_login = $ssh_session_login
	@ssh_session_passwd = $ssh_session_passwd
	@ssh_session_remote_host_ip = $ssh_session_remote_host_ip
	
	#on spŽcifie la page (erb/haml) a afficher
	erb :serverssh
end


post '/server/ssh' do
	#on spŽcifie la var de session du titre
	@title = 'SSH connection configuration'
	
	#on spŽcifie les vars de session des elements du formulaire
	@ssh_session_login = params[:loginssh]
	@ssh_session_passwd = params[:passwdssh]
	@ssh_session_remote_host_ip = params[:remotehostip]
	
	#et du coup, les vars globals qui en dŽcoulent
	$ssh_session_login = @ssh_session_login
	$ssh_session_passwd = @ssh_session_passwd
	$ssh_session_remote_host_ip = @ssh_session_remote_host_ip
	
	#on debug
	puts $ssh_session_login
	puts $ssh_session_passwd
	puts $ssh_session_remote_host_ip
	
	#on spŽcifie la page (erb/haml) a afficher
	erb :serverssh
end

#session vars test3: post + ssh + callbck output [from global vars]
post '/server/ssh/cmd' do

	#on spŽcifie une variable de session pour le titre
	@title = 'SSH configuration'
	
	#on recup des diffŽrentes vars de session (juste pour les afficher)
	@ssh_session_login = $ssh_session_login
	@ssh_session_passwd = $ssh_session_passwd
	@ssh_session_remote_host_ip = $ssh_session_remote_host_ip
	
	#session vars from global ssh vars (originally from the ssh configuraion form)
	@username = $ssh_session_login
	@password = $ssh_session_passwd
	@hostname = $ssh_session_remote_host_ip
	
	#session var from post
	@cmd = params[:cmdssh]
	
	#connection au remote host en ssh
 	begin
    	ssh = Net::SSH.start(@hostname, @username, :password => @password)
    	ssh_cmd_res = ssh.exec!(@cmd)
    	ssh.close
    	puts ssh_cmd_res #print du resultat de la commande dans la console [sur le server]
    	@ssh_cmd_output = ssh_cmd_res #enregistrement du resultat de la commande dans une var de session [a partir d une var locale]
  	rescue
    	puts "Unable to connect to #{@hostname} using #{@username}/#{@password}"
    	@ssh_cmd_output = "Unable to connect to #{@hostname} using #{@username}/#{@password}"
  	end
  	
	erb :serverssh
	
end # end of < post '/testconnectssh' do >



