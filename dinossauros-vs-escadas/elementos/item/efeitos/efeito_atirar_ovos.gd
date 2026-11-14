class_name EfeitoAtirarOvos
extends EfeitoReliquia

@export var quantidade_ovos: int = 2
@export var dano: float = 3.0
@export var velocidade: float = 300.0
@export var espalhamento: float = 0.2

func aplicar(player: Player) -> void:
	var componente := player.get_node_or_null("ComponenteAtirarOvos") as ComponenteAtirarOvos
	if componente == null:
		componente = ComponenteAtirarOvos.new()
		componente.name = "ComponenteAtirarOvos"
		player.add_child(componente)

	componente.quantidade_ovos = quantidade_ovos
	componente.dano = dano
	componente.velocidade = velocidade
	componente.espalhamento = espalhamento
