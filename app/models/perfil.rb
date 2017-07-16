class Perfil < ApplicationRecord

	has_many :users
	validates :nome, presence:true


	def to_s
		self.nome
	end


end
