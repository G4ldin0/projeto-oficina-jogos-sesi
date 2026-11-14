class_name PedestalReliquia
extends RigidBody2D

@export var reliquia: Reliquia:
	set(valor):
		reliquia = valor
		if is_node_ready():
			_atualizar_visual()

@onready var sprite_reliquia: Sprite2D = $SpriteReliquia

func _ready() -> void:
	freeze = true
	_atualizar_visual()

func definir_reliquia(valor: Reliquia) -> void:
	reliquia = valor

func _atualizar_visual() -> void:
	if not is_instance_valid(sprite_reliquia):
		return

	sprite_reliquia.texture = reliquia.sprite if reliquia != null else null
	sprite_reliquia.visible = reliquia != null and reliquia.sprite != null

func _on_area_interacao_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player") or reliquia == null:
		return

	var jogador := body as Player
	if jogador == null:
		return

	jogador.componente_inventario.add_reliquia(reliquia)
	reliquia = null
	_atualizar_visual()
