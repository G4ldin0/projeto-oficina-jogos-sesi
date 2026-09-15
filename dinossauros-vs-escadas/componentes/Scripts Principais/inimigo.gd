class_name Inimigo
extends Entidade

@onready var jogador = get_tree().get_first_node_in_group("player")

func _ready():
	super._ready()

func _physics_process(_delta: float) -> void:
	var direcao = global_position.direction_to(jogador.global_position)
	velocity = direcao * velocidade
	
	move_and_slide()

func morrer() -> void:
	queue_free()

func receber_dano(valor: float) -> void:
	super.receber_dano(valor)
	
	if vida <= 0:
		morrer()
