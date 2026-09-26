extends Node2D
class_name GerenciadorDeMapa

var salas:Array[Sala]
var salas_concluidas:Array[Sala]
@onready var camera:Camera2D = %Camera2D
@onready var jogador:Player = %Jogador

@export var sala_inicial:Sala

func _ready():
	jogador.position = sala_inicial.position
	camera.position = sala_inicial.position
	
	for sala in $salas.get_children():
		salas.append(sala)
		if sala == sala_inicial:
			continue
		sala.process_mode = Node.PROCESS_MODE_DISABLED


func ativar_sala(sala:Sala):
	sala.process_mode = Node.PROCESS_MODE_PAUSABLE

func trocar_sala(porta:Area2D) -> void:
	var sala_alvo:Sala
	for sala in salas:
		if sala.portas.has(porta):
			sala_alvo = sala
			break
	
	if sala_alvo == null: 
		print('sala não encontrada')
		return
	
	jogador.set_physics_process(false)
	var tween = create_tween().tween_property(camera, "position", sala_alvo.global_position, 2.0)
	await tween.finished
	jogador.set_physics_process(true)
	
	jogador.position = porta.global_position + (sala_alvo.global_position - porta.global_position).normalized() * 150.0
	ativar_sala(sala_alvo)
