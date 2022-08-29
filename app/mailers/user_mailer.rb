class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.account_activation.subject
  #
  def account_activation(usuario)
    @usuario = usuario
    mail to: usuario.email, subject: t(:msg_subject_ativacao_conta)
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(usuario)
    @usuario = usuario
    mail to: usuario.email, subject: t(:msg_subject_recuperacao_senha)
  end
  
  def test(email)
    mail to: email, subject: "Hello World!"
  end
end
