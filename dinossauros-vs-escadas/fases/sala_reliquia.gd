class_name SalaReliquia
extends Sala

@onready var pedestal: PedestalReliquia = $PedestalReliquia
var reliquia_disponivel: Reliquia

func definir_reliquia(reliquia: Reliquia) -> void:
	reliquia_disponivel = reliquia
	if is_node_ready():
		pedestal.definir_reliquia(reliquia)

func entrar_na_sala() -> void:
	if not sala_iniciada:
		pedestal.definir_reliquia(reliquia_disponivel)
		super.entrar_na_sala()
