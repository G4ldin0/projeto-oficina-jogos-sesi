extends Node2D
class_name Sala

var inimigos:Array[Inimigo]
var pode_sair:bool = false

func _ready() -> void:
	_liberar_sala($Inimigos.get_child_count() == 0)
	
	for inimigo in $Inimigos.get_children():
		inimigos.append(inimigo as Inimigo)
		inimigo.morreu.connect(_matar_inimigo.bind(inimigo))

func _matar_inimigo(inimigo:Inimigo):
	inimigos.remove_at(inimigos.find(inimigo))
	if inimigos.is_empty():
		_liberar_sala(true)

func _liberar_sala(ativar:bool):
	pode_sair = ativar
	for porta:Area2D in $Portas.get_children():
		porta.monitoring = ativar
