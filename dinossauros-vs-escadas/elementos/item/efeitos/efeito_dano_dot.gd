class_name EfeitoDanoDot
extends EfeitoItem

@export var ataque: StringName = &"Mordida"
@export var dano_por_tick: float = 1.0
@export var quantidade_ticks: int = 3
@export var intervalo: float = 0.5
@export var duracao: float = 10.0

func aplicar(player: Player) -> void:
	if not player.efeitosAtaques.has(ataque):
		return

	var efeito := Callable(self, "_aplicar_dano")
	player.efeitosAtaques[ataque].append(efeito)
	await player.get_tree().create_timer(duracao).timeout

	if is_instance_valid(player) and player.efeitosAtaques.has(ataque):
		player.efeitosAtaques[ataque].erase(efeito)

func _aplicar_dano(entidade: Entidade, jogador: Player) -> void:
	for _indice in quantidade_ticks:
		await jogador.get_tree().create_timer(intervalo).timeout
		entidade.receber_dano(dano_por_tick)
