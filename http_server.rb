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
  data = client.read(headers["Content-Length"].to_i)  # Read the POST data as specified in the header

  puts "data post method", data                                           # Do what you want with the POST data
  mydata=CGI::parse(data)
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

