extends Projetil

var dano:float

func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.receber_dano(dano)
		queue_free()
