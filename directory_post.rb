require "./mydatabase"
require "./directory"
require "./mydirectory"

class DirectoryPost < Mydirectory
    def rendermycss(partial)
      p "RENDER MY CSS"
      p partial
      
      @css+="<link href=\"/css/"+partial+"\" rel=\"stylesheet\"/>"
      p @css
      
    end
    def render(array,partial,as)
      p "hi REDER"
      p array, partial, as
      p "array"
      arrayfinal=""
      mypath=__dir__+@path+"/"+partial
      p "------my   path-----"
      p mypath
      array.each do |rr|

      mycontent=File.read(__dir__+@path.gsub("./","/")+"/"+partial)
      p "------my   content-----"
      p mycontent
      p rr
      eval("@#{as}=rr")
      k=mycontent.count("<%=")
      mycontent=mycontent.split("<%=")
      mycontent.map! do |h|
        g=h.index("%>")
        p g
        h=h.sub("%>","")
        az=""
        if g != -1 and g != nil
        begin
          p (h[0..(g-1)].strip.squish)
          az=eval(""+h[0..(g-1)].strip.squish)
        rescue
          begin
          az=eval("@"+h[0..(g-1)].strip.squish)
          rescue
          az="undefined"
          end
        end
        else
          g=0
        end
        p az
        p h[g..-1]
        az+h[g..-1]
      end
      mycontent=mycontent.join("")
      arrayfinal+=mycontent
      end
      arrayfinal
    end
  def newpost
    @post=Post.new(@params)
    if @post.save
      p "ok pot created"
    else
      #create_new
      p "error pot not created"
    end
  end
  def render_my_figure
    mycontent=File.read(__dir__+@path.gsub("./","/")+"/"+@pagename)
    k=mycontent.count("<%=")
      mycontent=mycontent.split("<%=")
      mycontent.map! do |h|
        g=h.index("%>")
        p g
        h=h.sub("%>","")
        az=""
        if g != -1 and g != nil
        begin
          p (h[0..(g-1)].strip.squish)
          az=eval(h[0..(g-1)].strip.squish)
        rescue
          begin
          az=params[h[0..g].strip.squish]
          rescue
          az="undefined"
          begin
          az=eval("self.class."+h[0..(g-1)].strip.squish)
          rescue
          begin
          az=eval("@"+h[0..(g-1)].strip.squish)
          rescue
          az="undefined"

          end


          end

          end

        end
        else
          g=0
        end
        p az
        p h[g..-1]
        az+h[g..-1]
      rescue 
        ""
      end
      mycontent=mycontent.join("")
    p "mY CONTENT"
    p mycontent
    @content= mycontent
    if @params.is_a?(Array)
    @params.each_with_index do |u,i|
      mycontent=mycontent.gsub("{{param[#{i+1}]}}",u)
    end
    end
    @main=mycontent
  end
  def initialize(path,words,pagename,params=[],mydata=[])


    @css=""
    @js=""
    @directory=__dir__
    @path=path
    @params=params
    if @params==[]
      @params={}
    end
    mydata.each do |a,b|
      @params[a]=b[0]
    end
    @title=words
    @pagename=pagename
    @nav=true
    @header=true
    @footer=true
    
    p @params

    p "-- css --"
    p @css
    render_my_figure


  end
  def header
    @nav && @header ? File.read(__dir__+"/nav/header.html") : ""
  end
  def nav
    @nav
  end
  def footer
    @nav && @footer ? File.read(__dir__+"/nav/footer.html") : ""
  end
  def set_path=(x)
    @path=x
  end
  def get_path
    @path
  end
  def file(param = true)
  end
  def title
    @title
  end
  def main
    @main
  end
  def css
    @css
  end
  def js
    @js
  end
end
