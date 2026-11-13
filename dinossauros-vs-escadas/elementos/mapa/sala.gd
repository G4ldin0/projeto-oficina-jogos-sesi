extends Node2D
class_name Sala

var inimigos:Array[Inimigo]
var pode_sair:bool = false
var sala_iniciada: bool = false

func entrar_na_sala() -> void:
	if sala_iniciada:
		return

	sala_iniciada = true
	_liberar_sala($Inimigos.get_child_count() == 0)
	
	for inimigo in $Inimigos.get_children():
		var inimigo_entidade := inimigo as Inimigo
		if inimigo_entidade == null:
			continue
		inimigos.append(inimigo_entidade)
		inimigo_entidade.morreu.connect(_matar_inimigo.bind(inimigo_entidade))

func _matar_inimigo(inimigo:Inimigo):
	inimigos.remove_at(inimigos.find(inimigo))
	if inimigos.is_empty():
		_liberar_sala(true)

func _liberar_sala(ativar:bool):
	pode_sair = ativar
	for porta:Porta in $Portas.get_children():
		porta.trocar_acesso_porta(ativar)
