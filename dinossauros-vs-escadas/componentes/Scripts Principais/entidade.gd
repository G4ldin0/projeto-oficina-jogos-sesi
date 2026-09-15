class_name Entidade
extends CharacterBody2D

@export var vida_maxima: float = 100
@export var velocidade: float = 200
@export var dano: float = 10

var vida: float

func _ready() -> void:
	vida = vida_maxima

func receber_dano(valor: float) -> void:
	vida -= valor
