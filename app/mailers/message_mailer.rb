class MessageMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.message_mailer.contact_me.subject
  #
  def contact_me(message)
    @body = message.body
    @nome = message.nome
    @telefone = message.telefone
    @email = message.email
    mail to: "columbamaster@gmail.com", from: "admin@columbamaster.com"
  end
end
