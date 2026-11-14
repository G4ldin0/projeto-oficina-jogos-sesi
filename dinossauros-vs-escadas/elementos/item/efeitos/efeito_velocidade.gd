class_name EfeitoVelocidade
extends EfeitoReliquia

@export var aumento: float = 25.0

func aplicar(player: Player) -> void:
	player.velocidade += aumento
