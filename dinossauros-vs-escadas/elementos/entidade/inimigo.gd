class_name Inimigo
extends Entidade

@onready var jogador = get_tree().get_first_node_in_group("player")
@onready var podeAtacar = true
@onready var emKnockBack = false

enum Estado {
	IDLE,
	PERSEGUINDO,
	ATACANDO,
	MORTO
}
var estadoAtual = Estado.IDLE

func _ready() -> void:
	super._ready()

func estado_idle():
	estadoAtual = Estado.PERSEGUINDO

func estado_perseguindo():
	if emKnockBack:
		move_and_slide()
		return
	var distancia = global_position.distance_to(jogador.global_position)
	if distancia > 100:
		var direcao = global_position.direction_to(jogador.global_position)
		velocity = direcao * velocidade
	else:
		velocity = Vector2.ZERO
		estadoAtual = Estado.ATACANDO

func estado_atacando():
	var distancia = global_position.distance_to(jogador.global_position)
	if distancia <= 100:
		atacar()
	else:
		estadoAtual = Estado.PERSEGUINDO

func estado_morto():
	return

func atacar() -> void:
	if not podeAtacar:
		return
	jogador.receber_dano(dano)
	print("Jogador recebeu ", dano, " de dano! Vida:", jogador.vida)
	podeAtacar = false
	
	if not is_inside_tree():
		return
	
	await  get_tree().create_timer(1.0).timeout
	podeAtacar = true

func _physics_process(_delta: float) -> void:
	match estadoAtual:
		Estado.IDLE:
			estado_idle()
		Estado.PERSEGUINDO:
			estado_perseguindo()
		Estado.ATACANDO:
			estado_atacando()
		Estado.MORTO:
			estado_morto()
	
	if not is_inside_tree():
		return
	move_and_slide()

func morrer() -> void:
	morreu.emit()
	queue_free()
	

func receber_dano(valor: float) -> void:
	if estadoAtual == Estado.MORTO:
		return
	super.receber_dano(valor)
	if vida <= 0:
		estadoAtual = Estado.MORTO
		await get_tree().create_timer(0.35).timeout
		morrer()

func knockback(direcao: Vector2, forca: float) -> void:
	emKnockBack = true
	velocity = direcao * forca
	await get_tree().create_timer(0.1).timeout
	emKnockBack = false
	velocity = Vector2.ZERO
