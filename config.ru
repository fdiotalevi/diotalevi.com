require 'sinatra'
require 'yaml'
 
set :environment, :production
disable :run

$config = YAML.load_file('./config/persona.yaml')
require File.join(File.dirname(__FILE__), 'app', 'persona')
run Sinatra::Application