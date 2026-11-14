class_name SalaReliquia
extends Sala

const RELIQUIAS: Array[Reliquia] = [
	preload("res://elementos/item/reliquias/novo_coracao.tres"),
	preload("res://elementos/item/reliquias/botas.tres"),
	preload("res://elementos/item/reliquias/ovos.tres"),
	preload("res://elementos/item/reliquias/six_e_seven.tres")
]

@onready var pedestal: PedestalReliquia = $PedestalReliquia

func entrar_na_sala() -> void:
	if sala_iniciada:
		return

	pedestal.definir_reliquia(RELIQUIAS.pick_random())
	super.entrar_na_sala()
