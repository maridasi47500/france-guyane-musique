require 'socket'                                         
require 'cgi'

require './directory'
require './directory_post'
require './mydirectory'
@words="mon site"
@path="./"
p "aller sur le localhost:8000"

def render_figure_new(pagename,words,path,params=[])
  myProgram=Directory.new(path,words,pagename,params)
  title=myProgram.title
  header=myProgram.header
  footer=myProgram.footer
  css=myProgram.css
  p ' -- my css --'
  p css
  main=myProgram.main
  js=myProgram.js
  x=File.read("./index.html") % [title, css, header,main,footer, js]

end
def render_figure_data(pagename,words,path,params=[],mydata=[])
  @myProgram=DirectoryPost.new(path,words,pagename,params,mydata)
  title=@myProgram.title
  header=@myProgram.header
  footer=@myProgram.footer
  css=@myProgram.css
  p ' -- my css --'
  p css
  main=@myProgram.main
  js=@myProgram.js
  x=File.read("./index.html") % [title, css, header,main,footer, js]

end
def render_figure(pagename,words,path,params=[])
  myProgram=Directory.new(path,words,pagename,params)
  title=myProgram.title
  header=myProgram.header
  footer=myProgram.footer
  css=myProgram.css
  p ' -- my css --'
  p css
  main=myProgram.main
  js=myProgram.js
  x=File.read("./index.html") % [title, css, header,main,footer, js]

end
def render_my_figure(pagename,words,path,params=[])
  myProgram=Mydirectory.new(path,words,pagename,params)
  title=myProgram.title
  header=myProgram.header
  footer=myProgram.footer
  css=myProgram.css
  p ' -- my css --'
  p css
  main=myProgram.main
  js=myProgram.js
  x=File.read("./index.html") % [title, css, header,main,footer, js]

end

socket = TCPServer.new(8000)                               
def error404(params = [])
render_figure("404.html", "rien trouvé", "./error",params)
end
def myposts(params = [])
 p params
 myparams={title: params[0]}
render_my_figure("index.html", "", "./posts",myparams)
end
def createmypost(params = [],mydata=[])
 p params
 z=render_figure_data("ok.html", "", "./posts",params,mydata)
 @myProgram.newpost
 z
end
def createpost(params = [])
 p params
 render_my_figure("new.html", "", "./posts",params)
end
def firstpage(params = [])
 p params
render_figure("customer.html", "hi customer", "./customer",params)
end
def home(params = [])
render_figure("index.html", "hi customer", "./home",params)
end
def datareach(params = [])
render_figure("index.html", "hi customer", "./datareach",params)
end
def soda(params = [])
render_figure("index.html", "hi customer", "./soda",params)
end
@post_routes={
/^\/posts/ => "createmypost",
}
@routes={
/^\/posts\/new/ => "createpost",
/^\/loisirs\/(.*?)$/ => "myposts",
/^\/customer\/(.*?)$/ => "firstpage",
/^\/soda$/ => "soda",
/^\/$/ => "home",
/^\/datareach$/ => "datareach"
}
  def deal_data(data,headers,remainbytes)
  boundary = "Boundary"
  line=data.next
  p "line:"
  p line
  remainbytes -= (line).length
  if !line.include?(boundary)
      return [false, "Content NOT begin with boundary",""]
  end
  line = data.next
  remainbytes -= (line).length
  fn = line.scan(/Content-Disposition.*name="image"; filename="(.*)"/)
  p fn
  if !fn[0]
      p [false, "Can't find out file name...",""]
  else
  path = "uploads"

  myfilename=(0..8).map{ (65 + rand(26)).chr}.join+fn[0]

  fn = Rails.root.join(path, myfilename)
  p(fn)
  line = data.next
  remainbytes -= (line).length
  begin
      out = File.open(fn, 'wb')
  rescue
      return [false, "Can't create file to write, do you have permission to write?",""]
  end
  preline = data.next
  p preline
  remainbytes -= (preline).length
  while remainbytes > 0
      line = data.next
      p line
      remainbytes -= (line).length
      if line.include?(boundary)
          preline = preline[0..-1]
          if preline.end_with?('\r')
              preline = preline[0..-1]
          end
          out.write(preline)
          out.close
          return [True, "ipload '%s' found success!" % myfilename,{image:myfilename}]
      else
          out.write(preline)
          preline = line
      end
  end
  end
  title = line.scan(/Content-Disposition.*name="title"/)
  p title 
  if !title[0]
      p [false, "Can't find out title...",""]
  else
  mytitle=""
  line = data.next
  p line
  remainbytes -= (line).length
  preline = data.next
  p preline
  remainbytes -= (preline).length
  while remainbytes > 0
      line = data.next
      p line
      remainbytes -= (line).length
      if line.include?(boundary)
          preline = preline[0..-1]
          if preline.end_with?('\r\n')
              preline = preline[0..-1]
          end
          mytitle+=(preline)
          return [True, "title found success!" % myfilename,{title:mytitle}]
      else
          mytitle+=(preline)
          preline = line
      end
  end
  end
  content = line.scan(/Content-Disposition.*name="content"/)
  p content
  if !content[0]
      p [false, "Can't find out content...",""]
  else
  mycontent=""
  line = data.next
  remainbytes -= (line).length
  preline = data.next
  p preline
  remainbytes -= (preline).length
  while remainbytes > 0
      line = data.next
      p line
      remainbytes -= (line).length
      if line.include?(boundary)
          preline = preline[0..-1]
          if preline.end_with?('\r\n')
              preline = preline[0..-1]
          end
          mycontent+=(preline)
          return [True, "content found success!" % myfilename,{content:mycontent}]
      else
          mycontent+=(preline)
          preline = line
      end
  end
  end


  return [false, "Unexpect Ends of data.",""]
  rescue => e
  return [false,e.inspect,""]
  end

loop do                                                  
  routefound=false
  client = socket.accept                                 
  first_line = client.gets                               
  if first_line
  verb, path, _ = first_line.split                       
  else
  verb, path, _ = [nil,nil,nil]
  end
  headers = {}
  while line = client.gets.split(' ', 2)              # Collect HTTP headers
    break if line[0] == ""                            # Blank line means no more headers
    headers[line[0].chop] = line[1].strip             # Hash headers by type
  end
  p "headers"
  #p headers
  data = client.read(headers["Content-Length"].to_i)  # Read the POST data as specified in the header

  #puts "data post method", data                                           # Do what you want with the POST data

  boundary = "Boundary"
  remainbytes = headers['content-length'].to_i
  p remainbytes
  data = data.each_line


  mydata={}
  begin
  msg,msg2,title=deal_data(data,headers,remainbytes)
  p msg, msg2
  mydata=mydata.merge(title) if title != ""
  msg,msg2,title=deal_data(data,headers,remainbytes)
  p msg, msg2
  mydata=mydata.merge(title) if title != ""
  rescue => e
  p e.inspect
  end

  begin
  msg,msg2,title=deal_data(data,headers,remainbytes)
  p msg, msg2
  mydata=mydata.merge(title) if title != ""
  msg,msg2,title=deal_data(data,headers,remainbytes)
  p msg, msg2
  mydata=mydata.merge(title) if title != ""
  rescue => e
  p e.inspect
  end
  begin
  msg,msg2,title=deal_data(data,headers,remainbytes)
  p msg, msg2
  mydata=mydata.merge(title) if title != ""
  msg,msg2,title=deal_data(data,headers,remainbytes)
  p msg, msg2
  mydata=mydata.merge(title) if title != ""
  rescue => e
  p e.inspect
  end
  #mydata=CGI::parse(data)
  p mydata


  xx=nil
  if path != nil
  xx= path.split(".")[-1]
  end

  if xx != nil
  xx= xx.split("?")[0]
  end
  if xx != nil
  case xx
  when "js"
        response = "HTTP/1.1 200 OK\r\nContent-Type: text/javascript\r\n\r\n"+File.read(File.dirname(__FILE__)+path)
        client.puts(response)                              
        routefound=true
  when "css"
        response = "HTTP/1.1 200 OK\r\nContent-Type: text/css\r\n\r\n"+File.read(File.dirname(__FILE__)+path)
        client.puts(response)                              
        routefound=true
  when "png"
        response = "HTTP/1.1 200 OK\r\nContent-Type: image/png\r\n\r\n"+File.read(File.dirname(__FILE__)+path)
        client.puts(response)                              
        routefound=true
  else
  if verb == 'POST'                                       
    p "POST"
    p _
    @post_routes.each do |route, func|
      p func, route
      if result = path.match(route)         
        params=[]
        1.upto(10).each do |x|
          client_id = result[x]                             

          params << client_id if client_id
        rescue => e
          p e.inspect
          p "raté"
        end
        response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n"+eval("#{func}(params,mydata)")
        client.puts(response)                              
        routefound=true
      end                                                  
    end                                                  
  end
  if verb == 'GET'                                       
    @routes.each do |route, func|
      p func, route
      if result = path.match(route)         
        params=[]
        1.upto(10).each do |x|
          client_id = result[x]                             

          params << client_id if client_id
        rescue => e
          p e.inspect
          p "raté"
        end
        response = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n"+eval("#{func}(params)")
        client.puts(response)                              
        routefound=true
      end                                                  
    end                                                  
  end                                                    
  end
  end
  if !routefound
        params=[path]
        response = "HTTP/1.1 404 OK\r\nContent-Type: text/html\r\n\r\n"+eval("error404(params)")
        client.puts(response)                              
  end


  client.close                                           
end                                                      

socket.close  

