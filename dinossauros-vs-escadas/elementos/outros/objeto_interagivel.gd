class_name ObjetoInteragivel
extends Area2D

signal interagido(jogador: Player)

@export_multiline var texto_interacao: String = ""

@onready var texto: Label = %TextoInteracao

var jogador_na_area: Player

func _ready() -> void:
	texto.text = texto_interacao
	interagido.connect(func(args): print('funciona'))

func _unhandled_input(event: InputEvent) -> void:
	if jogador_na_area == null:
		return
	if event.is_action_pressed("interagir"):
		interagido.emit(jogador_na_area)

func _on_body_entered(body: Node2D) -> void:
	var jogador := body as Player
	if jogador != null:
		jogador_na_area = jogador
		texto.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body == jogador_na_area:
		jogador_na_area = null
		texto.visible = false
