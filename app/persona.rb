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
    pd = PostData.new it
    pd if pd.valid
  end
  erb :index
end

get '/:y/:m/:d/:name/' do
  @page = Post.new params[:y], params[:m], params[:d], params[:name]
  erb :post
end

get '/:y/:m/:d/:name' do            #wrong link, but WP supports it
  redirect "/#{params[:y]}/#{params[:m]}/#{params[:d]}/#{params[:name]}/"
end

get '/pages/:name' do
  @page = Page.new params[:name]
  erb :page
end


def to_url(str)
  
  return str.gsub(".txt", "/")
end

def to_title(str)
  str
end


class PostData
  attr_accessor :valid, :url, :title, :file_name, :date
  
  def initialize(str)
    @file_name = str
    @valid = /(\d{4}-\d{2}-\d{2})-([^\/]*)\.txt$/.match str    
    
    if @valid
      @url = @valid[1].gsub(/[-]/, "/") + "/" + @valid[2] + "/"
      @title = @valid[2].gsub(/[-]/, " ").capitalize
      @date = Date.strptime(@valid[1], '%Y-%m-%d')
    end    
  end
end

