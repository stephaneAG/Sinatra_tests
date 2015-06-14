require 'sinatra'
require 'sinatra/reloader' if development?

#on passe le chemin de la racine du site
get '/' do
	"Hello World!"
	#puts "Hello World!" pr affichage console 
end

#on passe un param en url
get '/bonjour/:nom' do
	"Bonjour #{params[:nom]}"
end

#on passe un splat en url ( renvoie l'Žtoile ss forme de hash [tableau qui contient de] )
get '/test/*' do
	params[:splat].inspect
end