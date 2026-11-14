class_name Ovo
extends Projetil

@export var dano: float = 3.0

func _on_body_entered(body: Node) -> void:
	if body is Inimigo:
		body.receber_dano(dano)
		queue_free()
