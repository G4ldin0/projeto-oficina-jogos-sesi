class_name Reliquia
extends Resource

@export var nome: String
@export var sprite: Texture2D
@export var efeitos: Array[EfeitoReliquia] = []

func aplicar(player: Player) -> void:
	for efeito in efeitos:
		if efeito != null:
			efeito.aplicar(player)
