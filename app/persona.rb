require 'rubygems'
require 'erb'
require 'bundler'
Bundler.setup

require 'sinatra'
require 'builder'
require File.join(File.dirname(__FILE__), './ext', 'file')
require File.join(File.dirname(__FILE__), '.', 'page')
require File.join(File.dirname(__FILE__), '.', 'post')


get '/' do 
  @posts = load_posts
  erb :index
end

get '/feed/' do
  builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title "Filippo Diotalevi"
        xml.description "Startups, technology, news"
        xml.link "http://diotalevi.com/"

        load_posts.first(10).each do |post|
          xml.item do
            xml.title post.title
            xml.link post.url
            xml.description post.content
            xml.pubDate post.date.rfc822()
            xml.guid post.url
          end
        end
      end
    end
  end
end

get '/feed' do
  redirect '/feed/'
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


def load_posts
  posts = Dir.entries('./contents/posts').sort.reverse.reject do |it|
    not it.end_with? '.txt'
  end
      
  posts.map do |it|
    Post.new it
  end  
end

