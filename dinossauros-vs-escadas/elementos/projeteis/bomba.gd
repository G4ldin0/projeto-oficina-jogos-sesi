extends Projetil

const DANO_BOMBA:float = 9.0

func _physics_process(delta: float) -> void:
	if velocidade > 0:
		velocidade -= 400 * delta
	else: velocidade = 0
	super._physics_process(delta)

func _on_body_entered(_body: Node) -> void:
	print(_body)

func _timeout() -> void:
	var bodies:Array[Node2D] = $areaBomba.get_overlapping_bodies()
	print(bodies)
	for body:Entidade in bodies:
		body.receber_dano(DANO_BOMBA)
	$Sprite2D.visible = false
	$areaBomba/spriteExplosao.play("default")
	await $areaBomba/spriteExplosao.animation_finished
	queue_free()
