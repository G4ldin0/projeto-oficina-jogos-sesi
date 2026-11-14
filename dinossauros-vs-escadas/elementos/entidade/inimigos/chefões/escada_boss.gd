class_name EscadaBoss
extends Inimigo

signal objeto_fim_criado(objeto: ObjetoInteragivel)

const CENA_DIABRETE: PackedScene = preload("res://elementos/entidade/inimigos/inimigo.tscn")
const CENA_ESQUELETO: PackedScene = preload("res://elementos/entidade/inimigos/Esqueleto.tscn")
const CENA_FIM_INTERAGIVEL: PackedScene = preload("res://elementos/outros/fim_interagivel.tscn")

@export var primeiro_esqueleto:bool = true
@export var distancia_minima: float = 180.0
@export var distancia_maxima: float = 300.0

var inimigos_spawnados: Array[Entidade] = []
var fim_interagivel_criado := false

@onready var sprite_morte: Sprite2D = %SpriteMorte
@onready var som_spawn: AudioStreamPlayer2D = %SomSpawn
@onready var som_movimento: AudioStreamPlayer2D = %SomMovimento
@onready var som_morte: AudioStreamPlayer2D = %SomMorte

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if som_movimento.stream != null and velocity.length_squared() > 0:
		if not som_movimento.playing:
			som_movimento.play()
	else:
		som_movimento.stop()

func estado_perseguindo() -> void:
	if not is_instance_valid(jogador):
		return

	if emKnockBack:
		return

	var distancia := global_position.distance_to(jogador.global_position)
	if distancia > distancia_maxima:
		velocity = global_position.direction_to(jogador.global_position) * velocidade
	elif distancia < distancia_minima:
		velocity = jogador.global_position.direction_to(global_position) * velocidade
	else:
		velocity = Vector2.ZERO

func estado_atacando() -> void:
	estadoAtual = Estado.PERSEGUINDO
	estado_perseguindo()

func morrer() -> void:
	morreu.emit()
	_criar_fim_interagivel()

	som_movimento.stop()
	if som_morte.stream != null:
		var som_final := som_morte.duplicate() as AudioStreamPlayer2D
		owner.add_child(som_final)
		som_final.global_position = global_position
		som_final.finished.connect(som_final.queue_free)
		som_final.play()

	var sprite_final := sprite_morte.duplicate() as Sprite2D
	owner.add_child(sprite_final)
	sprite_final.visible = true
	sprite_final.global_position = global_position
	queue_free()

func _criar_fim_interagivel() -> void:
	if fim_interagivel_criado:
		return

	fim_interagivel_criado = true
	var fim_interagivel := CENA_FIM_INTERAGIVEL.instantiate()
	get_parent().add_child(fim_interagivel)
	fim_interagivel.global_position = global_position
	var objeto := fim_interagivel as ObjetoInteragivel
	if objeto != null:
		objeto_fim_criado.emit(objeto)

func spawnar_inimigo() -> void:
	_limpar_inimigos_inativos()

	var cena_inimigo: PackedScene = CENA_ESQUELETO if primeiro_esqueleto else CENA_DIABRETE
	primeiro_esqueleto = not primeiro_esqueleto

	var inimigo := cena_inimigo.instantiate() as Entidade
	get_parent().add_child(inimigo)
	inimigo.global_position = _obter_posicao_spawn()
	inimigos_spawnados.append(inimigo)
	if som_spawn.stream != null:
		som_spawn.play()

func _obter_posicao_spawn() -> Vector2:
	return %PontoSpawn.global_position

func _limpar_inimigos_inativos() -> void:
	for indice in range(inimigos_spawnados.size() - 1, -1, -1):
		if not is_instance_valid(inimigos_spawnados[indice]):
			inimigos_spawnados.remove_at(indice)
