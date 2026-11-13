class_name InterfaceLoja
extends Interface

signal fechar_solicitado
signal cura_solicitada

@onready var botao_cura: Button = %BotaoCura

func _ready() -> void:
	ocultar()

func _unhandled_input(event: InputEvent) -> void:
	if visible and event.is_action_pressed("ui_cancel"):
		fechar_solicitado.emit()

func _on_fechar_pressed() -> void:
	fechar_solicitado.emit()

func _on_cura_pressed() -> void:
	cura_solicitada.emit()

func desativar_cura() -> void:
	botao_cura.disabled = true
