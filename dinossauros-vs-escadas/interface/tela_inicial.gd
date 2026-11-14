extends Control

@onready var tutorial: PanelContainer = %Tutorial
@onready var configuracoes: PanelContainer = %Configuracoes
@onready var volume_label: Label = %VolumeLabel

func _ready() -> void:
	tutorial.visible = false
	configuracoes.visible = false
	AudioStreamPlayer2d.tocar_musica_inicial()

func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://Game.tscn")

func _on_tutorial_pressed() -> void:
	tutorial.visible = true

func _on_fechar_tutorial_pressed() -> void:
	tutorial.visible = false

func _on_configuracoes_pressed() -> void:
	_atualizar_volume()
	configuracoes.visible = true

func _on_fechar_configuracoes_pressed() -> void:
	configuracoes.visible = false

func _on_aumentar_volume_pressed() -> void:
	AudioStreamPlayer2d.aumentar_volume()
	_atualizar_volume()

func _on_diminuir_volume_pressed() -> void:
	AudioStreamPlayer2d.diminuir_volume()
	_atualizar_volume()

func _atualizar_volume() -> void:
	volume_label.text = "Volume: %d%%" % AudioStreamPlayer2d.obter_volume_percentual()

func _on_sair_pressed() -> void:
	get_tree().quit()
