class_name EfeitoCura
extends EfeitoItem

@export var quantidade: float = 10.0

func aplicar(player: Player) -> void:
	player.curar_vida(quantidade)
