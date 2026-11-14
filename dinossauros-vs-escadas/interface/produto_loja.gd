class_name ProdutoLoja
extends Resource

@export var item: Item
@export var reliquia: Reliquia
@export_range(0, 999) var preco: int = 1
@export_range(0, 999) var quantidade_bombas: int = 0

func obter_nome() -> String:
	if reliquia != null:
		return reliquia.nome
	return item.nome if item != null else ""

func obter_sprite() -> Texture2D:
	if reliquia != null:
		return reliquia.sprite
	return item.sprite if item != null else null
