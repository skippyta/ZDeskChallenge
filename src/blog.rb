require 'date'

class Blog < Object
  def initialize(posts, header, bottom, renderer)
    @posts = posts
    @header = header
    @footer = bottom
    @renderer = renderer
  end

  class_eval do
    def all_posts
      @posts
    end
  end

  #Post subclass for more scalable post creation
  class Post < Object
    def initialize(title, time=Time.now)
      @title = title
      @comments = []
      @timestamp = time
    end

    def title
      @title
    end

    def timestamp
      @timestamp
    end

    def comments
      @comments
    end

    def add_comment (comment)
      @comments.push(comment)
    end
  end

  def html_div(content)
    "<div>" + content + "</div>"
  end

  def html_h1(content)
    ("<h1>" + content + "</h1>")
  end

  def current_post=(post)
    @current_post = post
  end

  def render
    output = [html_div(html_h1 @header)]
    for post in all_posts.sort{|a,b| a.timestamp.to_i <=> b.timestamp.to_i }
      self.current_post = post
      output = output + render_post
      output = output + render_comments()
    end
    output.push(html_div(@footer))
  end

  def render_post
    begin
      [html_div(@renderer.call(@current_post))]
    rescue
      []
    end
  end

  def render_comments
    [*@current_post.comments.each{|c| html_div(c)}]
  end

end

post1 = Blog::Post.new("I like Zendesk")
post1.add_comment("Dogs are awesome")

post2 = Blog::Post.new("I like Bananas")
post2.add_comment("Typos are awesome")

post3 = Blog::Post.new(nil)
post3.add_comment("wibbles are wobble")
post3.add_comment("yay")

posts = [post1, post2, post3]

renderer = Proc.new do |post|
  "<p>" + post.title.upcase + "</p>"
end

title = "My Blog"
footer = "Copyright Wobble (2012)"
blog = Blog.new(posts, title, footer, renderer)

puts blog.render