class_name EfeitoVidaMaxima
extends EfeitoReliquia

@export var aumento: float = 10.0

func aplicar(player: Player) -> void:
	player.vida_maxima += aumento
	player.vida += aumento
	player.vida_alterada.emit(player.vida, player.vida_maxima)
