extends Inimigo
class_name Esqueleto

const PROJETIL:PackedScene = preload("res://elementos/projeteis/osso.tscn")

func estado_idle():
	velocity = Vector2.ZERO

func _on_range_ataque_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		estadoAtual = Estado.PERSEGUINDO

func _on_range_ataque_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		estadoAtual = Estado.IDLE

func estado_perseguindo():
	if emKnockBack:
		move_and_slide()
		return
	var distancia = global_position.distance_to(jogador.global_position)
	if distancia > 200:
		var direcao = global_position.direction_to(jogador.global_position)
		velocity = direcao * velocidade
	else:
		velocity = Vector2.ZERO
		estadoAtual = Estado.ATACANDO

func estado_atacando():
	if not podeAtacar:
		return
	atacar()
	podeAtacar = false
	%CooldownAtirar.start()
	await %CooldownAtirar.timeout
	podeAtacar = true

func atacar() -> void:
	var direcao_de_ataque:Vector2 = global_position.direction_to(jogador.global_position).normalized()
	$RayCast2D.target_position = direcao_de_ataque * 600
	await get_tree().create_timer(0.25).timeout
	var novo_projetil:Projetil = PROJETIL.instantiate()
	novo_projetil.direcao = direcao_de_ataque
	novo_projetil.position = direcao_de_ataque * 100.0
	add_child(novo_projetil)
