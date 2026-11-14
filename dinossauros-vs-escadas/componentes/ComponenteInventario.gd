class_name ComponenteInventario
extends Node

signal recurso_alterado(nome_recurso: StringName, quantidade: int)
signal item_selecionado(item: Item)
signal reliquias_alteradas(reliquias: Array[Reliquia])

var moedas: int = 50:
	set(valor):
		moedas = maxi(valor, 0)
		recurso_alterado.emit(&"moedas", moedas)

var bombas: int = 10:
	set(valor):
		bombas = maxi(valor, 0)
		recurso_alterado.emit(&"bombas", bombas)
var _reliquias: Array[Reliquia] = []

var inventario:Array[Item] = []
var indice_item_selecionado := -1

func add_reliquia(reliquia: Reliquia) -> void:
	if reliquia == null or _reliquias.has(reliquia):
		return

	_reliquias.append(reliquia)
	reliquia.aplicar(get_parent() as Player)
	reliquias_alteradas.emit(_reliquias)

func obter_reliquias() -> Array[Reliquia]:
	return _reliquias

func possui_reliquia(reliquia: Reliquia) -> bool:
	return _reliquias.has(reliquia)

func add_item(item:Item) -> void:
	inventario.append(item)
	if item.get_class() != inventario.back().get_class():
		inventario.sort()
	if indice_item_selecionado == -1:
		selecionar_item(0)

func selecionar_item(indice: int) -> void:
	if indice < 0 or indice >= inventario.size():
		indice_item_selecionado = -1
		item_selecionado.emit(null)
		return

	indice_item_selecionado = indice
	item_selecionado.emit(inventario[indice])

func obter_item_selecionado() -> Item:
	if indice_item_selecionado == -1:
		return null
	return inventario[indice_item_selecionado]

func usar_item() -> Item:
	if indice_item_selecionado == -1: return null
	return inventario.pop_at(indice_item_selecionado)

func _unhandled_key_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("usar_item"):
		usar_item().usar(get_parent())
	if Input.is_action_just_pressed("selecionar_item_antes"):
		selecionar_item((indice_item_selecionado - 1) % inventario.size())
	if Input.is_action_just_pressed("selecionar_item_depois"):
		selecionar_item((indice_item_selecionado + 1) % inventario.size())
