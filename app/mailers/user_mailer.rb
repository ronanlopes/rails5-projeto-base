class UserMailer < ApplicationMailer

  default :from => 'BBA | Gestão de Empilhadeiras <bbaempilhadeiras@gear7.com.br>'

  def signup_email(usuario, password)
    @usuario = usuario
    @password = password
    mail(
      :to => @usuario.email,
      :subject => 'Cadastro no sistema de empilhadeiras (BBA)'
    )
  end

end