require 'socket'                                               
require 'test/unit'                                            

class ServerTest < Test::Unit::TestCase                        
  def test_http_customer_42                                         
    server = TCPSocket.open('localhost', 80)                 

    request = """
      GET /customers/42 HTTP/1.1\r\n
      Accept: plain/text\r\n
      \r\n
    """

    server.puts(request)                                       

    response = ''                                              

    while line = server.gets                                   
      response += line                                         
    end                                                        

    expected = """
      HTTP/1.1 200\r\n
      \r\n
      Hey, 42!\n
    """

    assert_equal expected, response

    server.close                                               
  end                                                          
end                                                            
