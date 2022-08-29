class Mensagem
  include ActiveModel::Model
  attr_accessor :nome, :email, :body, :telefone
  validates :nome, :email, :body, presence: true
  validates :telefone, length: { maximum: 15 }
end