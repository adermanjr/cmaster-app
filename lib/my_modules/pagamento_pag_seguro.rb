module MyModules
  module PagamentoPagSeguro
    
    def pagamento_pagseguro(usuario)
    
      payment = PagSeguro::PaymentRequest.new
      
      payment.reference = 123
      payment.notification_url = ""
      payment.redirect_url = ""
      
      payment.items << {
        id: 1,
        description: 'Assinatura MaterPombo',
        amount: 19.9,
      }
      
      response = payment.register
      
      puts response
      puts response.to_json
      puts response.body
      
      
    end
    
  end
end