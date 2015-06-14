require 'sinatra'
require 'sinatra/reloader' if development?

#on passe le chemin de la racine du site
get '/' do
	erb :index
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
