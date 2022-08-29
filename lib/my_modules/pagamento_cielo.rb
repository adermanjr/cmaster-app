require 'net/http'
require 'uri'
require 'json'

module MyModules
  module PagamentoCielo
    
    def cancelar_pagto(ambiente, id_plano, id_recorrencia_operadora)
      
      secrets = JSON.load(File.read('config/secrets/cielo_keys.json'))
      cielo_urls = JSON.load(File.read('config/cielo_urls.json'))
      
      headers["MerchantId"] = secrets[ambiente]['MerchantId']
      headers["MerchantKey"] = secrets[ambiente]['MerchantKey']
      headers["RequestId"] = id_plano
      
      # if plano.dtcancelamento < plano.dtinicio_pagto
        uri = URI.parse([cielo_urls[ambiente]['envio'], "1", "RecurrentPayment", id_recorrencia_operadora,"Deactivate"].join("/"))
        val = ""
      # else
      #   uri = URI.parse([cielo_urls[ambiente]['envio'], "1", "RecurrentPayment", plano.id_recorrencia_operadora,"EndDate"].join("/"))
      #   val = plano.dtcancelamento.strftime("%Y-%m-%d")
      # end
      
      client = Net::HTTP.new(uri.host, uri.port)
      client.use_ssl = true
  
      response = client.send_request("PUT", uri.request_uri, val, headers)
      
      # puts "response.code " + response.code
      
      return response
    end
    
    def efetuar_pagto_manual(ambiente, usuario, plano, cvc, dtini_pagto)
      
      secrets = JSON.load(File.read('config/cielo_secrets.json'))
      cielo_urls = JSON.load(File.read('config/cielo_urls.json'))
      pagamento = JSON.load(File.read('lib/my_modules/cielo_pagamento_base.json'))
      
      uri = URI.parse([cielo_urls[ambiente]['envio'], "1", "sales"].join("/"))
  
      headers = cielo_urls['headers']
      
      headers["MerchantId"] = secrets[ambiente]['MerchantId']
      headers["MerchantKey"] = secrets[ambiente]['MerchantKey']
      headers["RequestId"] = plano.id.to_s
      
      pagamento["MerchantOrderId"] = plano.id
      pagamento["Payment"]["Amount"] = (plano.valor_mensal * 100).to_i
      
      pagamento["Payment"]["CreditCard"]["CardNumber"] = usuario.numero_cartao.gsub("-","")
      pagamento["Payment"]["CreditCard"]["Holder"] = usuario.nome_cartao
      pagamento["Payment"]["CreditCard"]["ExpirationDate"] = usuario.dtexpirado
      pagamento["Payment"]["CreditCard"]["SecurityCode"] = cvc
      pagamento["Payment"]["CreditCard"]["Brand"] = usuario.bandeira_cartao
      pagamento["Payment"]["RecurrentPayment"]["StartDate"] = dtini_pagto.strftime("%Y-%m-%d")
      pagamento["Payment"]["RecurrentPayment"]["AuthorizeNow"] = (dtini_pagto.month == Time.now.month ? "True" : "False")
      
      client = Net::HTTP.new(uri.host, uri.port)
      client.use_ssl = true
  
      response = client.send_request("POST", uri.request_uri, pagamento.to_json, headers)
      puts uri
      puts "response.code " + response.code
      puts response
      
      return response
      
    end
    
    def consultar_pagamento(ambiente, plano)
      
      puts ambiente
      puts plano.url_recorrencia_operadora
      
      secrets = JSON.load(File.read('config/cielo_secrets.json'))
      
      headers["MerchantId"] = secrets[ambiente]['MerchantId']
      headers["MerchantKey"] = secrets[ambiente]['MerchantKey']
      
      
      uri = URI.parse(plano.url_recorrencia_operadora)
      
      val = ""
      
      client = Net::HTTP.new(uri.host, uri.port)
      client.use_ssl = true
  
      response = client.send_request("GET", uri.request_uri, val, headers)
      puts response
      # puts "response.code " + response.code
      
      return response
    end
    
    def pagamento_api(usuario, ambiente)
    
      secrets = JSON.load(File.read('config/cielo_secrets.json'))
      
      # Configure seu merchant
      merchant = Cielo::API30.merchant(secrets[ambiente]['MerchantId'], secrets[ambiente]['MerchantKey'])
      
      # Crie uma instância de Sale informando o ID do pagamento
      sale = Cielo::API30::Sale.new("124")
      
      # Crie uma instância de Customer informando o nome do cliente
      sale.customer = Cielo::API30::Customer.new("Fulano de Tal")
      
      # Crie uma instância de Payment informando o valor do pagamento
      sale.payment = Cielo::API30::Payment.new(15700)
      
      # Informe o tipo de pagamento que será utilizado
      sale.payment.type = Cielo::API30::Payment::PAYMENTTYPE_CREDITCARD
      
      # Crie  uma instância de Credit Card utilizando os dados de teste
      sale.payment.credit_card = Cielo::API30::CreditCard.new(security_code: "123", brand: "Visa")
      sale.payment.credit_card.expiration_date = "12/2020"
      sale.payment.credit_card.holder = "Fulano de Tal"
      sale.payment.credit_card.card_number = "0000000000000001"
      
      puts " - "
      puts sale.to_json
      puts ambiente
      
      # Configure o SDK com seu merchant e o ambiente apropriado para criar a venda
      if ambiente == 'sandbox'
        cielo_api = Cielo::API30.client(merchant, Cielo::API30::Environment::sandbox)
      else
        cielo_api = Cielo::API30.client(merchant, Cielo::API30::Environment::production)
      end
      # Crie a venda na Cielo
      sale = cielo_api.create_sale(sale)
      
      # Com a venda criada, já temos o ID do pagamento, TID e demais dados retornados pela Cielo
      puts sale
      puts sale.payment.payment_id
      puts sale.to_json
      
    end
    
  end
end