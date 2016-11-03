require './lib/utils'
require './lib/urls'
require './lib/login'
require 'pry'

class FutApi

  login_response = {}


  def login(email, password, secret, platform, tfCode)
    login_req = Login.new()
    begin
      # binding.pry
      login_resp = login_req.login(email, password, secret, platform)
    rescue Exception => e
      puts e
      puts e.backtrace
      exit 1
    end

    login_response = login_resp



  end

end