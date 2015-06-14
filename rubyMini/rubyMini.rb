#je customize le tout pour fonctionner avec siriproxy server
require 'rubygems'
require 'appscript'
require 'osax'
#require 'net/ssh'

# set :host,"192.168.1.7"
# set :password,"jackassapple"
# set :password,"jackassapple"
# 
# get '/testconnect' do
# 	
# 	#static for the moment, we'll see later
# 	HOST = '192.168.1.7'
# 	USER = 'stephaneadamgarnier'
# 	PASS = 'jackassapple'
# 
# 	Net::SSH.start( HOST, USER, :password => PASS ) do|ssh|
# 		output=ssh.exec!('ls')
# 		puts output
# 	end
# 	
# end
# 
# get '/connectconfig' do
# 	erb :server
# end
# 
# post '/setconnectconfig' do
# 	erb :server
# end

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
	puts "The parent script starts off directory: #{Dir.pwd}"
	
	shell_output = ""
	IO.popen('irb', 'r+') do |pipe|
  		pipe.puts("puts 'Hello world, from irb, inside of a Ruby script!'")
  		#files = `ls`
  		#pipe.puts files.split("\n").sort
  		pipe.close_write
  	shell_output = pipe.read
	end

	puts shell_output
	
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

#partie sinatra, pour l interface http/ruby
require 'sinatra'
require 'sinatra/reloader' if development?

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


get '/hello/:prenom' do
	erb :index
end

get '/form' do
	erb :form
end

post '/bonjour' do
	erb :bonjour
end
