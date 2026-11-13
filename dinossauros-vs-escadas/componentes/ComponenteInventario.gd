class_name ComponenteInventario
extends Node

signal recurso_alterado(nome_recurso: StringName, quantidade: int)

var moedas: int = 0:
	set(valor):
		moedas = maxi(valor, 0)
		recurso_alterado.emit(&"moedas", moedas)

var bombas: int = 10:
	set(valor):
		bombas = maxi(valor, 0)
		recurso_alterado.emit(&"bombas", bombas)
var _reliquias:Array[Item] = []

var inventario:Array[Item] = [ItemCarne.new()]

func add_item(item:Item) -> void:
	inventario.append(item)
	if item.get_class() != inventario.back().get_class():
		inventario.sort()

func use_item(index:int) -> Item:
	return inventario.pop_at(index)
