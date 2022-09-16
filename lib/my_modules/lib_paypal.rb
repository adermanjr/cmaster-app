require 'net/http'
require 'uri'
require 'json'

module MyModules
  module LibPaypal
    def paypal_read_keys
      return ENV['RAILS_ENV'] == 'production' ? JSON.load(ENV['PAYPAL_JSON']) : JSON.load(File.read('config/secrets/paypal_data.json'))
    end

    def cancel_subscription(env, subscriptionId)
      
      paypal_data = paypal_read_keys
      url_base = paypal_data[env]['url']
      
      ret = get_token(url_base, paypal_data[env]['clienteID'], paypal_data[env]['secret'])
      return ret if !ret[:success]
      
      uri = URI.parse("#{url_base}/v1/billing/subscriptions/#{subscriptionId}/cancel")
      
      # Set up Net::HTTP to use SSL
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  
      # Build the request
      req = Net::HTTP::Post.new uri.request_uri

      # Issue the request and return the response.
      http.start
      req.add_field('Content-Type', 'application/json')
      req.add_field('Authorization', "Bearer #{ret[:token]}")
      req.body = '{"reason": "Not satisfied with the service"}'
      res = http.request req
      http.finish
      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        { "success": true}
      else
        ret_body = JSON.parse(res.body)
        {"success": false, "error": ret_body["details"][0]["issue"]}
      end
      
    end
    
    def activate_subscription(env, subscriptionId)
      
      paypal_data = paypal_read_keys
      url_base = paypal_data[env]['url']
      
      ret = get_token(url_base, paypal_data[env]['clienteID'], paypal_data[env]['secret'])
      return ret if !ret[:success]
      
      uri = URI.parse("#{url_base}/v1/billing/subscriptions/#{subscriptionId}/activate")
      puts "uri #{uri}"
      
      # Set up Net::HTTP to use SSL
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  
      # Build the request
      req = Net::HTTP::Post.new uri.request_uri

      # Issue the request and return the response.
      http.start
      req.add_field('Content-Type', 'application/json')
      req.add_field('Authorization', "Bearer #{ret[:token]}")
      req.body = '{"reason": "Reactivating the subscription"}'
      res = http.request req
      http.finish
      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        #puts 'body'
        #puts res.body
        puts 'res'
        puts res
        puts '# OK'
        { "success": true}
      else
        ret_body = JSON.parse(res.body)
        {"success": false, "error": ret_body["details"][0]["issue"]}
      end
      
    end
    
    def get_subscription(env, subscriptionId)
      
      paypal_data = paypal_read_keys
      url_base = paypal_data[env]['url']
      
      ret = get_token(url_base, paypal_data[env]['clienteID'], paypal_data[env]['secret'])
      return ret if !ret[:success]
      
      url_show_subscription = "#{url_base}/v1/billing/subscriptions/#{subscriptionId}"
      
      uri = URI.parse(url_show_subscription)
      puts "uri #{uri}"
      
      # Set up Net::HTTP to use SSL
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  
      # Build the request
      req = Net::HTTP::Get.new uri.request_uri

      # Issue the request and return the response.
      http.start
      req.add_field('Content-Type', 'application/json')
      req.add_field('Authorization', "Bearer #{ret[:token]}")
      res = http.request req
      http.finish
      
      ret_body = JSON.parse(res.body)
      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        { "success": true, "body": ret_body}
      else
        {"success": false, "error": ret_body["details"][0]["issue"]}
      end
    end
    
    def get_token(url_base, clientId, secret)
      #https://ruby-doc.org/stdlib-2.6.5/libdoc/net/http/rdoc/Net/HTTP.html
      #https://stackoverflow.com/questions/35823368/ruby-nethttp-post-parameters-strip-error
      puts '*********************'
      puts url_base
      puts clienteID
      puts secret
      uri = URI.parse("#{url_base}/v1/oauth2/token")
      puts uri
      puts '*********************'
      
      # Set up Net::HTTP to use SSL
      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  
      # Build the request
      req = Net::HTTP::Post.new uri.request_uri

      # Issue the request and return the response.
      http.start
      req.add_field('Accept', 'application/json')
      req.add_field('Accept-Language', 'en_US')
      req.add_field('Content-Type', 'application/x-www-form-urlencoded')
      req.basic_auth clientId, secret
      req.body = "grant_type=client_credentials"
      res = http.request req
      http.finish
      case res
      when Net::HTTPSuccess, Net::HTTPRedirection
        ret_body = JSON.parse(res.body)
        { "success": true, "token": ret_body['access_token']}
      else
        { "success": false, "error": res.value}
      end
    end
    
  end
end
