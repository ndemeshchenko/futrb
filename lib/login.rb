require_relative './ea_hasher.rb'
require_relative './urls'
require_relative './utils'
require 'http-cookie'
require 'curb'
require 'zlib'
require 'uri'
require 'json'
require 'pry'

class Login
  attr_accessor :default_headers, :login_details

  @login_response = {
    nucleusId: nil,
    shardInfos: nil,
    shard: nil,
    persona: nil,
    sessionData: nil,
    apiRequest: nil
  }

  def login(email, password, secret, platform)
    if (!email || !email.is_a?(String) || email.strip().length <= 0)
      raise ::Exception, "Email is empty."
    end

    if (!password || !password.is_a?(String) || password.strip().length <= 0)
      raise ::Exception, "Password is empty."
    end

    if (!secret || !secret.is_a?(String) || email.strip().length <= 0)
       raise ::Exception, "Secret is empty."
    end

    if (!platform || !platform.is_a?(String) || platform.strip().length <= 0)
      raise ::Exception, "Platform is empty."
    end

    if (!Login.get_platform(platform))
        raise ::Exception, "Platform is invalid."
    end

    # if (!__.isFunction(tfCodeCb))
    #   raise Exception "tfCodeCb is not a function."
    # end

    # if (!__.isFunction(loginCb))
    #   return loginCb(new Error("tfCodeCb is not a function."));
    # end

    @login_details = {
        "email": email,
        "password": password,
        "secret": EAHasher.generate(secret),
        "gameSku": Login.get_game_sku(platform),
        "platform": Login.get_platform(platform)
    }

    @default_headers = {
      "User-Agent" => "Mozilla/5.0 (Windows NT 6.3; WOW64; Trident/7.0; rv:11.0) like Gecko",
      "Accept" => "text/html, application/xhtml+xml, */*",
      "Accept-Encoding" => "gzip, deflate",
      "Accept-Language" => "en-US,en;q=0.8",
      "Connection" => "keep-alive",
      "DNT" => "1",
      "Cache-Control" => "no-cache"
    }

    get_main();
  end

  def get_cookie_jar_json()
    # return jar._jar.serializeSync();
  end

  def set_cookie_jar_json(json)
      # jar._jar = CookieJar.deserializeSync(json);
  end

  def self.get_game_sku(platform)
    case platform
      when 'pc'
        return 'FFA17PCC'
      when 'ps3'
        return 'FFA17PS3'
      when 'ps4'
        return 'FFA17PS4'
      when 'x360'
        return 'FFA17XBX'
      when 'xone'
        return 'FFA17XBO'
    end
    return nil
  end

  def self.get_platform(platform)
    case platform
      when 'pc'
        return "pc"
      when 'ps3'
      when 'ps4'
        return 'ps3'
      when 'x360'
      when 'xone'
        return '360';
    end
    return nil
  end

  def get_main()
    response = fetch(Urls.urls[:login][:main])

    # defaultRequest.get(urls.login.main,function(error, response, body){
    #   if(error) return loginDetails.loginCb(error);

    #   if(body.indexOf("<title>FIFA Football | FUT Web App | EA SPORTS</title>") > 0) return getNucleus();

    #   if(body.indexOf("<title>Log In</title>") > 0) return loginForm(response.request.href);

    #   loginDetails.loginCb(new Error("Unknow response. Unable to login."));
    # });
  end


  def fetch(uri_str, limit=10)
    # You should choose better exception.
    raise ArgumentError, 'HTTP redirect too deep' if limit == 0


    c = Curl::Easy.new(uri_str)
    c.ssl_verify_peer = false
    c.follow_location = true
    c.verbose = true
    c.perform

    sio = StringIO.new( c.body )
    gz = Zlib::GzipReader.new( sio )
    page = gz.read()
    binding.pry
    # url = URI.parse(uri_str)
    # http = Net::HTTP.new(uri.host, uri.port)
    # http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE # You should use VERIFY_PEER in production

    # req = Net::HTTP::Get.new(url.path, @default_headers)

    # # binding.pry
    # response = Net::HTTP.start(url.host, url.port) do |http|
    #   http.use_ssl = true
    #   http.request(req)
    # end
    # case response
    # when Net::HTTPSuccess     then response
    # when Net::HTTPRedirection then fetch(response['location'], limit - 1)
    # else
    #   response.error!
    # end
  end




end