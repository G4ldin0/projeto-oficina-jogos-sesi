class_name EfeitoCor
extends EfeitoItem

@export var cor:Color = Color.WHITE
@export var duracao:float = 5.0

func aplicar(player: Player) -> void:
	player.modulate = cor
	await player.get_tree().create_timer(duracao).timeout
	player.modulate = Color.WHITE
