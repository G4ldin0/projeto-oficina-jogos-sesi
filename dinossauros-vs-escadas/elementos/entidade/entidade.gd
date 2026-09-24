class_name Entidade
extends CharacterBody2D

signal morreu

@export var vida_maxima: float = 100
@export var velocidade: float = 200
@export var dano: float = 10
@export var sprite: Sprite2D


var vida: float

func _ready() -> void:
	vida = vida_maxima
	
func receber_dano(valor: float) -> void:
	vida -= valor
	
	sprite.self_modulate = Color(1,0,0,0.8)
	await get_tree().create_timer(0.1).timeout
	sprite.self_modulate = Color.WHITE
