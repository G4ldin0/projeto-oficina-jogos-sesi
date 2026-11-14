class_name Item
extends Resource

@export var nome: String
@export var sprite:Texture2D
@export var efeitos: Array[EfeitoItem] = []

func usar(player:Player) -> void:
	for efeito in efeitos:
		if efeito != null:
			efeito.aplicar(player)
