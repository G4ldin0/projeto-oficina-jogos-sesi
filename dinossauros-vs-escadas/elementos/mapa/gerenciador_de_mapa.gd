extends Node2D
class_name GerenciadorDeMapa

var salas:Array[Sala]
var salas_concluidas:Array[Sala]
var camera_acompanha_jogador := false
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

func _process(_delta: float) -> void:
	if camera_acompanha_jogador:
		camera.global_position = jogador.global_position

func definir_camera_acompanha_jogador(acompanhar: bool) -> void:
	camera_acompanha_jogador = acompanhar
	if acompanhar:
		camera.global_position = jogador.global_position

func trocar_sala(porta:Porta) -> void:
	print(porta)
	var sala_alvo: Sala = porta.sala
	definir_camera_acompanha_jogador(false)
	jogador.set_physics_process(false)
	var tween = create_tween().tween_property(camera, "global_position", sala_alvo.global_position, 2.0)
	await tween.finished
	sala_alvo.entrar_na_sala()
	jogador.set_physics_process(true)
	
	jogador.global_position = porta.get_posicao_sair()
	sala_alvo.process_mode = Node.PROCESS_MODE_PAUSABLE
