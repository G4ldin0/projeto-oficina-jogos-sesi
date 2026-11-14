class_name ComponenteCompanheiros
extends Node2D

const CENA_COMPANHEIRO: PackedScene = preload("res://elementos/entidade/companheiro.tscn")

@export var dano: float = 2.0
@export var distancia_investida: float = 120.0
@export var duracao_investida: float = 0.25
@export var intervalo_entre_ataques: float = 0.1

var companheiros: Array[CompanheiroAtaque] = []

func _ready() -> void:
	for indice in 2:
		var companheiro := CENA_COMPANHEIRO.instantiate() as CompanheiroAtaque
		if companheiro == null:
			continue

		companheiro.dano = dano
		companheiro.distancia_investida = distancia_investida
		companheiro.duracao_investida = duracao_investida
		companheiro.offset_acompanhamento = Vector2(-42, -28) if indice == 0 else Vector2(-42, 28)
		add_child.call_deferred(companheiro)
		companheiros.append(companheiro)

func atacar(direcao: Vector2) -> void:
	if direcao == Vector2.ZERO or companheiros.is_empty():
		return

	var direcao_normalizada := direcao.normalized()
	for companheiro in companheiros:
		await companheiro.investir(direcao_normalizada)
		if intervalo_entre_ataques > 0.0:
			await get_tree().create_timer(intervalo_entre_ataques).timeout
