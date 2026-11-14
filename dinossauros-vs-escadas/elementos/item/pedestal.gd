class_name PedestalReliquia
extends ObjetoInteragivel

@export var reliquia: Reliquia:
	set(valor):
		reliquia = valor
		if is_node_ready():
			_atualizar_visual()

@onready var sprite_reliquia: Sprite2D = $SpriteReliquia

func _ready() -> void:
	super._ready()
	interagido.connect(_coletar_reliquia)
	_atualizar_visual()

func definir_reliquia(valor: Reliquia) -> void:
	reliquia = valor

func _atualizar_visual() -> void:
	if not is_instance_valid(sprite_reliquia):
		return

	sprite_reliquia.texture = reliquia.sprite if reliquia != null else null
	sprite_reliquia.visible = reliquia != null and reliquia.sprite != null

func _coletar_reliquia(jogador: Player) -> void:
	if reliquia == null:
		return

	jogador.componente_inventario.add_reliquia(reliquia)
	reliquia = null
	_atualizar_visual()
