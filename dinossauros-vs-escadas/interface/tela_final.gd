extends Control

func _ready() -> void:
	AudioStreamPlayer2d.tocar_musica_final()

func _on_voltar_inicio_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/tela_inicial.tscn")

func _on_sair_pressed() -> void:
	get_tree().quit()
