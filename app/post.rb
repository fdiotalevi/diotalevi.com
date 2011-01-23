class Post
  
  attr_reader :content, :title, :author
  
  def initialize(y,m,d,name)
    f = File.open("./contents/posts/#{y}-#{m}-#{d}-#{name}.txt","r")
    @content =  f.content_as_string
    @title = f.metadata 'title'
    @author = f.metadata 'author'          
    f.close
  end
    
end