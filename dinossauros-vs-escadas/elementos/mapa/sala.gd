extends Node2D
class_name Sala

@onready var gerenciador_de_mapa:GerenciadorDeMapa = get_tree().root.get_node("GerenciadorDeMapa")
var inimigos:Array[Inimigo]
var portas:Array[Area2D]
var pode_sair:bool = false

@export var salas:Dictionary[Area2D, Area2D] = {}

func _ready() -> void:
	if $Inimigos.get_child_count() == 0:
		_liberar_sala()
	
	for inimigo in $Inimigos.get_children():
		inimigos.append(inimigo as Inimigo)
		inimigo.morreu.connect(_matar_inimigo.bind(inimigo))
	
	for porta in $Portas.get_children():
		portas.append(porta)

func _matar_inimigo(inimigo:Inimigo):
	inimigos.remove_at(inimigos.find(inimigo))
	if inimigos.is_empty():
		_liberar_sala()


func _liberar_sala():
	pode_sair = true
	for porta:Area2D in $Portas.get_children():
		porta.monitoring = true

func _on_porta_body_entered(body:Node2D, porta:Area2D) -> void:
	if body.is_in_group("player"):
		gerenciador_de_mapa.trocar_sala(salas[porta])
