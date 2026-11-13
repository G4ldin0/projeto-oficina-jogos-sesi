extends Node2D
class_name GerenciadorDeMapa

var salas:Array[Sala]
var salas_concluidas:Array[Sala]
@onready var camera:Camera2D = %Camera2D
@onready var jogador:Player = %Jogador

@export var sala_inicial:Sala

func _ready():
	sala_inicial.entrar_na_sala()
	jogador.position = sala_inicial.position
	camera.position = sala_inicial.position
	
	for sala in $salas.get_children():
		salas.append(sala)
		if sala == sala_inicial:
			continue
		sala.process_mode = Node.PROCESS_MODE_DISABLED
	
	for porta:Porta in get_tree().get_nodes_in_group("porta"):
		porta.trocar_sala.connect(trocar_sala)

func trocar_sala(porta:Porta) -> void:
	var sala_alvo = porta.owner
	print(sala_alvo)
	jogador.set_physics_process(false)
	var tween = create_tween().tween_property(camera, "global_position", sala_alvo.global_position, 2.0)
	await tween.finished
	sala_alvo.entrar_na_sala()
	jogador.set_physics_process(true)
	
	jogador.position = porta.get_posicao_sair()
	sala_alvo.process_mode = Node.PROCESS_MODE_PAUSABLE
