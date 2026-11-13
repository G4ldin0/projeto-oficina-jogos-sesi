class_name Moeda
extends Area2D

@export var valor_minimo: int = 1
@export var valor_maximo: int = 3

var valor: int

func _ready() -> void:
	valor = randi_range(valor_minimo, valor_maximo)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	var jogador := body as Player
	if jogador == null:
		return

	jogador.componente_inventario.moedas += valor
	queue_free()
