extends Projetil

func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.receber_dano(2.0)
		queue_free()
