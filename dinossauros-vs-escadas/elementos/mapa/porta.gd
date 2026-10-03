@tool
class_name Porta
extends Area2D

signal trocar_sala(proxima_porta:Porta)

@onready var sprite:Sprite2D = %Sprite2D
@onready var sala:Sala = get_parent().get_parent() #  feio

func _validate_property(property: Dictionary):
	if property.name == "outra_porta":
		update_configuration_warnings()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings:PackedStringArray = []
	if sala == null and get_parent() is Node2D:
		warnings.append("necessário ligar esta porta a outra.")
	return warnings

@export var outra_porta:Porta = null:
	set(i):
		outra_porta = i
		update_configuration_warnings()

@export var direcao_sair:Vector2 = Vector2.DOWN:
	set(dir):
		if dir.length() == 0.0: dir = Vector2.DOWN
		direcao_sair = dir.normalized()
		if %direcao:
			%direcao.target_position = direcao_sair * 50

func _ready() -> void:
	%direcao.target_position = direcao_sair * 50

func get_posicao_sair() -> Vector2:
	return global_position + direcao_sair * 100.0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and outra_porta:
		trocar_sala.emit(outra_porta)
