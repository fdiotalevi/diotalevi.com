require 'rubygems'
require 'erb'
require 'bundler'
Bundler.setup

require 'sinatra'
require File.join(File.dirname(__FILE__), './ext', 'file')
require File.join(File.dirname(__FILE__), '.', 'page')
require File.join(File.dirname(__FILE__), '.', 'post')


get '/' do 
  @posts = Dir.entries('./contents/posts').sort.reverse.reject do |it|
    not it.end_with? '.txt'
  end
      
  @posts = @posts.map do |it|
    Post.new it
  end
  erb :index
end

get '/:y/:m/:d/:name/' do
  @page = Post.from_url params[:y], params[:m], params[:d], params[:name]
  erb :post
end

get '/:y/:m/:d/:name' do            #wrong link, but WP supports it
  redirect "/#{params[:y]}/#{params[:m]}/#{params[:d]}/#{params[:name]}/"
end

get '/pages/:name' do
  @page = Page.new params[:name]
  erb :page
end

