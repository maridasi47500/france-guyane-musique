require "./mydatabase"
require "./directory"

class Mydirectory < Directory
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
      @ifs=[]
      tosearch=0
      while cherche_if and tosearch < mycontent.length do
      @if={:if=>[],:elsif=>[],:else=>[]}
      cherche_if=mycontent.index do |h|
         cond1=h.squish.strip.index("if ") == 0 
         begin
         mystr=x.strip.squish
         cond2=eval(mystr[3..(mystr.index("%>") - 1)])
         rescue
         cond2=false
         end
         cond1 && cond2
      end
      if cherche_if
      ii=mycontent[cherche_if].index("%>")+2
      cond=eval(mycontent[cherche_if][3..-3])
      @if[:if] << {mycontent[cherche_if][ii..-1] => cond}
      else
        break
      end
      tosearch=cherche_if
      cherche_elif = 0
      while cherche_elif == 0 do
      cherche_elif=mycontent[tosearch..-1].index do |h|
         cond1=h.squish.strip.index("elsif ") == 0 
         begin
         mystr=x.strip.squish
         cond2=eval(mystr[3..(mystr.index("%>") - 1)])
         rescue
         cond2=false
         end
         cond1 && cond2
      end
      cherche_elif = cherche_elif == 0 ? cherche_elif : nil
      if cherche_elif
      ii=mycontent[cherche_elif].index("%>")+2
      cond=eval(mycontent[cherche_elif][3..-3])
      @if[:elif] << {mycontent[cherche_elif][ii..-1] => cond}
      else
        break
      end
      tosearch += cherche_elif == 0 ? 1 : 0
      end
      cherche_else=0
      while cherche_else == 0 do
      cherche_else=mycontent[tosearch..-1].index do |h|
         cond1=h.squish.strip == ("else")
         cond1
      end
      cherche_else = cherche_else == 0 ? cherche_else : nil
      tosearch += cherche_else == 0 ? 1 : 0
      end
      tosearch=0
      @ifs << @if
      end
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
  def initialize(path,words,pagename,params=[])


    @css=""
    @js=""
    @directory=__dir__
    @path=path
    @params=params
    @title=words
    @pagename=pagename
    @nav=true
    @header=true
    @footer=true
    
    p @params
    mycontent=File.read(__dir__+path.gsub("./","/")+"/"+pagename)
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
          begin
          az=eval("self.class."+h[0..(g-1)].strip.squish)
          rescue
          az="undefined"

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
    if params.is_a?(Array)
    params.each_with_index do |u,i|
      mycontent=mycontent.gsub("{{param[#{i+1}]}}",u)
    end
    end
    @main=mycontent
    p "-- css --"
    p @css


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
