class_name ComponenteAtirarOvos
extends Node2D

const CENA_OVO: PackedScene = preload("res://elementos/projeteis/ovo.tscn")

@export var quantidade_ovos: int = 2
@export var dano: float = 3.0
@export var velocidade: float = 300.0
@export var espalhamento: float = 0.2

func atirar(direcao: Vector2) -> void:
	if direcao == Vector2.ZERO:
		return

	var direcao_base := direcao.normalized()
	for indice in quantidade_ovos:
		var ovo := CENA_OVO.instantiate() as Ovo
		if ovo == null:
			continue

		var fator := float(indice) - float(quantidade_ovos - 1) / 2.0
		ovo.direcao = direcao_base.rotated(fator * espalhamento)
		ovo.velocidade = velocidade
		ovo.dano = dano
		ovo.global_position = global_position + direcao_base * 90.0
		get_tree().current_scene.add_child(ovo)
