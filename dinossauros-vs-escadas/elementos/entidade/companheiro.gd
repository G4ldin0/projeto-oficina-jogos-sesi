class_name CompanheiroAtaque
extends Area2D

var dano: float = 2.0
var distancia_investida: float = 120.0
var duracao_investida: float = 0.25
var offset_acompanhamento := Vector2.ZERO
var atacando := false
var inimigos_atingidos: Array[Node] = []

func _ready() -> void:
	collision_layer = 0
	collision_mask = 4
	body_entered.connect(_on_body_entered)

func _process(_delta: float) -> void:
	if atacando:
		return

	position = offset_acompanhamento

func investir(direcao: Vector2) -> void:
	if atacando:
		return

	atacando = true
	inimigos_atingidos.clear()
	rotation = direcao.angle()
	var destino := offset_acompanhamento + direcao * distancia_investida
	var tween := create_tween()
	tween.tween_property(self, "position", destino, duracao_investida * 0.5)
	tween.tween_property(self, "position", offset_acompanhamento, duracao_investida * 0.5)
	await tween.finished
	atacando = false

func _on_body_entered(body: Node2D) -> void:
	if not atacando or body in inimigos_atingidos:
		return
	if not body is Inimigo:
		return

	inimigos_atingidos.append(body)
	body.receber_dano(dano)
