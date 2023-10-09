require "./mydatabase"
class Directory
  def initialize(path,words,pagename,params=[])
    @css=""
    @js=""
    @directory=__dir__
    @path=path
    @params=[]
    @title=words
    @pagename=pagename
    @nav=true
    @header=true
    @footer=true
    mycontent=File.read(__dir__+path.gsub("./","/")+"/"+pagename)
    p mycontent, params
    if mycontent and params.is_a?(Array) and params[0]
    p mycontent
    params.each_with_index do |u,i|
      mycontent=mycontent.gsub("{{param[#{i+1}]}}",u)
    end
    @main=mycontent
    end


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
