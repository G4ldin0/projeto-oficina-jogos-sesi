class_name EfeitoCompanheiros
extends EfeitoReliquia

@export var dano: float = 2.0
@export var distancia_investida: float = 120.0
@export var duracao_investida: float = 0.25

func aplicar(player: Player) -> void:
	var componente := player.get_node_or_null("ComponenteCompanheiros") as ComponenteCompanheiros
	if componente == null:
		componente = ComponenteCompanheiros.new()
		componente.name = "ComponenteCompanheiros"
		player.add_child(componente)

	componente.dano = dano
	componente.distancia_investida = distancia_investida
	componente.duracao_investida = duracao_investida
