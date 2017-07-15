class Perfil < ApplicationRecord

	has_many :users
	validates :nome, presence:true

end
