class User < ApplicationRecord

	devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  belongs_to :perfil

  validates :perfil, :nome, :email, presence: true

end